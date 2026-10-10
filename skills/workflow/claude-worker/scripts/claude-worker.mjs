#!/usr/bin/env node
// Claude Code ultra worker for Hermes: on/off + account + model switch, and delegation through ctx-kit's worker.mjs.
// State: <HermesHome>/kiridev-worker.json. Usage: node claude-worker.mjs on|off|status|account <1-3>|model <opus|sonnet>|scope <impl|code|web|all>|register
//        node claude-worker.mjs run [--web] [--readonly] [--cwd DIR] "<task>"   (exit 3 = disabled, 4 = ctx-kit not found)
//        --web marks a web research task and adds the built-in WebSearch/WebFetch tools to the worker.
//        scope decides what is delegated (out of scope = exit 3). Task kind: --web = web research, --readonly = investigation, else implementation.
//        impl = implementation only (default), code = implementation + investigation, web = web research only, all = everything.
import { spawnSync } from 'node:child_process';
import { existsSync, mkdirSync, readFileSync, writeFileSync } from 'node:fs';
import { join } from 'node:path';
import { homedir } from 'node:os';
import { fileURLToPath } from 'node:url';

const DEFAULTS = { enabled: false, account: 1, model: 'opus', scope: 'impl' };
const ACCOUNTS = [1, 2, 3];
const MODELS = ['opus', 'sonnet'];
const SCOPES = { impl: ['implementation'], code: ['implementation', 'investigation'], web: ['web research'], all: ['implementation', 'investigation', 'web research'] };
const hermesHome = process.env.HERMES_HOME || join(process.env.LOCALAPPDATA || homedir(), 'hermes');
const stateFile = join(hermesHome, 'kiridev-worker.json');

function load() {
  let s = {};
  try { s = JSON.parse(readFileSync(stateFile, 'utf8')) ?? {}; } catch {}
  return {
    enabled: typeof s.enabled === 'boolean' ? s.enabled : DEFAULTS.enabled,
    account: ACCOUNTS.includes(s.account) ? s.account : DEFAULTS.account,
    model: MODELS.includes(s.model) ? s.model : DEFAULTS.model,
    scope: Object.hasOwn(SCOPES, s.scope) ? s.scope : DEFAULTS.scope,
  };
}
function save(s) {
  mkdirSync(hermesHome, { recursive: true });
  writeFileSync(stateFile, JSON.stringify(s) + '\n');
  console.log(line(s));
}
const line = s => `worker: ${s.enabled ? 'ON' : 'OFF'} account=${s.account} model=${s.model} scope=${s.scope}`;
const configDir = n => join(homedir(), `.claude-account${n}`);
function fail(code, msg) { console.error(msg); process.exit(code); }

function kitWorker() {
  let root = process.env.CTXKIT_ROOT;
  if (!root) { try { root = readFileSync(join(homedir(), '.claude-ctxkit', 'root.txt'), 'utf8').trim(); } catch {} }
  const p = root && join(root, 'kit', 'worker.mjs');
  return p && existsSync(p) ? p : null;
}

const [cmd, ...rest] = process.argv.slice(2);
const state = load();
switch (cmd) {
  case 'on': save({ ...state, enabled: true }); break;
  case 'off': save({ ...state, enabled: false }); break;
  case 'status': console.log(line(state)); break;
  case 'account': {
    const n = Number(rest[0]);
    if (!ACCOUNTS.includes(n)) fail(2, `account must be one of ${ACCOUNTS.join(', ')}. Unchanged: ${line(state)}`);
    if (!existsSync(join(configDir(n), '.credentials.json')))
      fail(2, `account ${n} is not logged in (${join(configDir(n), '.credentials.json')} not found). Log in with claude-${n}.cmd first. Unchanged: ${line(state)}`);
    save({ ...state, account: n });
    break;
  }
  case 'model':
    if (!MODELS.includes(rest[0])) fail(2, `model must be one of ${MODELS.join(', ')}. Unchanged: ${line(state)}`);
    save({ ...state, model: rest[0] });
    break;
  case 'scope':
    if (!Object.hasOwn(SCOPES, rest[0])) fail(2, `scope must be one of ${Object.keys(SCOPES).join(', ')}. Unchanged: ${line(state)}`);
    save({ ...state, scope: rest[0] });
    break;
  case 'run': {
    if (!state.enabled) { console.log('WORKER_DISABLED: do this task yourself.'); process.exit(3); }
    const worker = kitWorker();
    if (!worker) { console.log('WORKER_UNAVAILABLE: ctx-kit worker.mjs not found (CTXKIT_ROOT or ~/.claude-ctxkit/root.txt). Do this task yourself.'); process.exit(4); }
    const web = rest.indexOf('--web');
    const kind = web >= 0 ? 'web research' : rest.includes('--readonly') ? 'investigation' : 'implementation';
    if (!SCOPES[state.scope].includes(kind)) {
      console.log(`WORKER_DISABLED: ${kind} is not delegated (scope=${state.scope}). Do this task yourself.`);
      process.exit(3);
    }
    if (web >= 0) rest.splice(web, 1, '--tools', 'WebFetch,WebSearch');
    const r = spawnSync(process.execPath, [worker, '--model', state.model, ...rest],
      { stdio: 'inherit', env: { ...process.env, CLAUDE_CONFIG_DIR: configDir(state.account) } });
    if (r.error) fail(1, `failed to start worker: ${r.error.message}`);
    process.exit(r.status ?? 1);
  }
  case 'register': {
    // Hermes plugin commands run without the LLM and show up in the "/" completion popup (quick_commands do not).
    const self = fileURLToPath(import.meta.url);
    const cmds = {
      'worker-on': [['on'], 'Claude Code ワーカーを使う'],
      'worker-off': [['off'], 'Claude Code ワーカーを使わない（初期値）'],
      'worker-status': [['status'], 'ワーカーの現在の状態を表示'],
      'worker-1': [['account', '1'], 'ワーカーの Claude アカウントを 1 にする（初期値）'],
      'worker-2': [['account', '2'], 'ワーカーの Claude アカウントを 2 にする'],
      'worker-3': [['account', '3'], 'ワーカーの Claude アカウントを 3 にする'],
      'worker-opus': [['model', 'opus'], 'ワーカーのモデルを opus にする（初期値）'],
      'worker-sonnet': [['model', 'sonnet'], 'ワーカーのモデルを sonnet にする'],
      'worker-impl': [['scope', 'impl'], '任せる範囲: 実装だけ（初期値）'],
      'worker-code': [['scope', 'code'], '任せる範囲: 実装とファイル調査'],
      'worker-web': [['scope', 'web'], '任せる範囲: Web 検索だけ'],
      'worker-all': [['scope', 'all'], '任せる範囲: すべて'],
    };
    const dir = join(hermesHome, 'plugins', 'kiridev-worker');
    mkdirSync(dir, { recursive: true });
    writeFileSync(join(dir, 'plugin.yaml'),
      'name: kiridev-worker\nversion: 1.0.0\ndescription: "/worker-* slash commands for the Claude Code worker (generated by claude-worker.mjs register)"\n');
    writeFileSync(join(dir, '__init__.py'), `# Generated by claude-worker.mjs register. Do not edit: re-run scripts/sync-hermes-skills.ps1.
import subprocess

NODE = ${JSON.stringify(process.execPath)}
SCRIPT = ${JSON.stringify(self)}
COMMANDS = ${JSON.stringify(cmds)}


def _handler(args):
    def run(_raw_args=""):
        r = subprocess.run([NODE, SCRIPT, *args], capture_output=True, text=True, encoding="utf-8", errors="replace", timeout=30)
        return (r.stdout + r.stderr).strip()
    return run


def register(ctx):
    for name, (args, description) in COMMANDS.items():
        ctx.register_command(name, handler=_handler(args), description=description)
`);
    const hermes = args => spawnSync(process.env.HERMES_EXE || 'hermes', args, { encoding: 'utf8' });
    const r = hermes(['plugins', 'enable', 'kiridev-worker']);
    if (r.error || r.status !== 0) fail(1, `hermes plugins enable kiridev-worker failed: ${r.error?.message ?? r.stderr ?? r.stdout}`);
    // quick_commands registered by older versions take precedence over plugin commands: remove them (absent = fine).
    for (const name of Object.keys(cmds)) hermes(['config', 'unset', `quick_commands.${name}`]);
    console.log(`Hermes plugin commands registered: ${Object.keys(cmds).map(n => '/' + n).join(' ')}`);
    break;
  }
  default:
    fail(2, 'usage: node claude-worker.mjs on|off|status|account <1-3>|model <opus|sonnet>|scope <impl|code|web|all>|register|run [--web] [--readonly] [--cwd DIR] "<task>"');
}
