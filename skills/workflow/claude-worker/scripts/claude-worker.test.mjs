// node --test skills/workflow/claude-worker/scripts/claude-worker.test.mjs
// Claude is never started: CTXKIT_ROOT points at a fake kit whose worker.mjs records how it was called.
import { test, beforeEach } from 'node:test';
import assert from 'node:assert/strict';
import { spawnSync } from 'node:child_process';
import { existsSync, mkdirSync, mkdtempSync, readFileSync, writeFileSync } from 'node:fs';
import { join, dirname } from 'node:path';
import { tmpdir } from 'node:os';
import { fileURLToPath } from 'node:url';

const SCRIPT = join(dirname(fileURLToPath(import.meta.url)), 'claude-worker.mjs');
let home, hermes, kitRoot, called;

beforeEach(() => {
  const t = mkdtempSync(join(tmpdir(), 'claude-worker-test-'));
  home = join(t, 'home'); hermes = join(t, 'hermes'); kitRoot = join(t, 'ctx'); called = join(t, 'called.json');
  for (const n of [1, 2]) { mkdirSync(join(home, `.claude-account${n}`), { recursive: true }); }
  writeFileSync(join(home, '.claude-account1', '.credentials.json'), '{}');
  mkdirSync(join(kitRoot, 'kit'), { recursive: true });
  writeFileSync(join(kitRoot, 'kit', 'worker.mjs'),
    `import { writeFileSync } from 'node:fs';
writeFileSync(process.env.TEST_CALLED, JSON.stringify({ argv: process.argv.slice(2), configDir: process.env.CLAUDE_CONFIG_DIR }));
console.log('FAKE_RESULT'); process.exit(Number(process.env.TEST_EXIT ?? 0));`);
});

function run(args, env = {}) {
  return spawnSync(process.execPath, [SCRIPT, ...args], { encoding: 'utf8',
    env: { ...process.env, HERMES_HOME: hermes, USERPROFILE: home, HOME: home, CTXKIT_ROOT: kitRoot, TEST_CALLED: called, ...env } });
}
const state = () => JSON.parse(readFileSync(join(hermes, 'kiridev-worker.json'), 'utf8'));
const calledInfo = () => JSON.parse(readFileSync(called, 'utf8'));

test('status without a state file shows the defaults (OFF, account 1, opus, scope impl)', () => {
  const r = run(['status']);
  assert.equal(r.status, 0);
  assert.equal(r.stdout.trim(), 'worker: OFF account=1 model=opus scope=impl');
});

test('a broken state file falls back to the defaults', () => {
  mkdirSync(hermes, { recursive: true });
  writeFileSync(join(hermes, 'kiridev-worker.json'), '{broken');
  assert.equal(run(['status']).stdout.trim(), 'worker: OFF account=1 model=opus scope=impl');
  writeFileSync(join(hermes, 'kiridev-worker.json'), '{"enabled":"yes","account":9,"model":"haiku","scope":"x"}');
  assert.equal(run(['status']).stdout.trim(), 'worker: OFF account=1 model=opus scope=impl');
});

test('on / off persist across invocations', () => {
  assert.equal(run(['on']).stdout.trim(), 'worker: ON account=1 model=opus scope=impl');
  assert.equal(run(['status']).stdout.trim(), 'worker: ON account=1 model=opus scope=impl');
  assert.equal(run(['off']).stdout.trim(), 'worker: OFF account=1 model=opus scope=impl');
  assert.equal(state().enabled, false);
});

test('run while OFF exits 3 and never starts the worker', () => {
  const r = run(['run', 'do something']);
  assert.equal(r.status, 3);
  assert.match(r.stdout, /^WORKER_DISABLED/);
  assert.equal(existsSync(called), false);
});

test('run while ON delegates with the default model and account, and returns the worker output', () => {
  run(['on']); run(['scope', 'all']);
  const r = run(['run', '--readonly', '--cwd', 'C:\\proj', 'do something']);
  assert.equal(r.status, 0);
  assert.match(r.stdout, /FAKE_RESULT/);
  const c = calledInfo();
  assert.deepEqual(c.argv, ['--model', 'opus', '--readonly', '--cwd', 'C:\\proj', 'do something']);
  assert.equal(c.configDir, join(home, '.claude-account1'));
});

test('run --web gives the worker the web tools', () => {
  run(['on']); run(['scope', 'all']);
  run(['run', '--web', '--readonly', 'search something']);
  assert.deepEqual(calledInfo().argv, ['--model', 'opus', '--tools', 'WebFetch,WebSearch', '--readonly', 'search something']);
});

test('scope limits what run delegates; out-of-scope tasks exit 3 without starting the worker', () => {
  run(['on']);
  // default scope impl: implementation only
  assert.equal(run(['run', 'edit']).status, 0);
  const inv = run(['run', '--readonly', 'look']);
  assert.equal(inv.status, 3);
  assert.match(inv.stdout, /^WORKER_DISABLED: investigation/);
  assert.equal(run(['run', '--web', '--readonly', 'search']).status, 3);

  assert.equal(run(['scope', 'code']).stdout.trim(), 'worker: ON account=1 model=opus scope=code');
  assert.equal(run(['run', '--readonly', 'look']).status, 0);
  const web = run(['run', '--web', 'search']);
  assert.equal(web.status, 3);
  assert.match(web.stdout, /^WORKER_DISABLED: web research/);
  assert.equal(run(['run', 'edit']).status, 0);

  run(['scope', 'web']);
  const code = run(['run', 'edit']);
  assert.equal(code.status, 3);
  assert.match(code.stdout, /^WORKER_DISABLED: implementation/);
  assert.equal(run(['run', '--web', 'search']).status, 0);

  assert.equal(run(['scope', 'bogus']).status, 2);
  assert.equal(state().scope, 'web');
  run(['scope', 'all']);
  assert.equal(run(['run', 'edit']).status, 0);
  assert.equal(run(['run', '--web', 'search']).status, 0);
});

test('run returns the worker exit code', () => {
  run(['on']);
  assert.equal(run(['run', 'x'], { TEST_EXIT: '1' }).status, 1);
});

test('run without ctx-kit exits 4', () => {
  run(['on']);
  const r = run(['run', 'x'], { CTXKIT_ROOT: join(kitRoot, 'missing') });
  assert.equal(r.status, 4);
  assert.match(r.stdout, /^WORKER_UNAVAILABLE/);
});

test('ctx-kit is resolved from ~/.claude-ctxkit/root.txt when CTXKIT_ROOT is unset', () => {
  mkdirSync(join(home, '.claude-ctxkit'), { recursive: true });
  writeFileSync(join(home, '.claude-ctxkit', 'root.txt'), kitRoot + '\\\r\n');
  run(['on']);
  assert.equal(run(['run', 'x'], { CTXKIT_ROOT: '' }).status, 0);
});

test('account switch is used by run and keeps ON/OFF', () => {
  writeFileSync(join(home, '.claude-account2', '.credentials.json'), '{}');
  run(['on']);
  assert.equal(run(['account', '2']).stdout.trim(), 'worker: ON account=2 model=opus scope=impl');
  run(['run', 'x']);
  assert.equal(calledInfo().configDir, join(home, '.claude-account2'));
});

test('account that is not logged in, missing or out of range is refused and state is unchanged', () => {
  for (const a of ['2', '3', '4', 'x']) {
    const r = run(['account', a]);
    assert.equal(r.status, 2, `account ${a}`);
    assert.equal(run(['status']).stdout.trim(), 'worker: OFF account=1 model=opus scope=impl');
  }
  assert.match(run(['account', '2']).stderr, /not logged in/);
});

test('model switch is used by run; invalid model is refused', () => {
  run(['on']);
  assert.equal(run(['model', 'sonnet']).stdout.trim(), 'worker: ON account=1 model=sonnet scope=impl');
  run(['run', 'x']);
  assert.deepEqual(calledInfo().argv, ['--model', 'sonnet', 'x']);
  assert.equal(run(['model', 'haiku']).status, 2);
  assert.equal(state().model, 'sonnet');
});

test('unknown subcommand exits 2', () => {
  assert.equal(run(['bogus']).status, 2);
});
