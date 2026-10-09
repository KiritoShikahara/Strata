// Rebuilds the payloads embedded at the end of install-strata-qwen.bat, so it works as a single file:
//   "::| " lines = strata-qwen.bat              (step 5 writes it out)
//   "::h " lines = strata-hermes.bat            (step 5 writes it out too)
//   "::+ " lines = strata-download.bat          (step 3 writes it out and runs it)
//   "::# " lines = qwen-skills/ as a base64 zip (step 6 unpacks it)
//   "::~ " lines = qwen-settings.js, base64     (step 7 runs it)
// Run after changing any of those sources:  node build-installer.js
const fs = require('fs');
const { execFileSync } = require('child_process');

const read = f => fs.readFileSync(f, 'utf8').replace(/\r/g, '');
const lines = f => read(f).replace(/\n+$/, '').split('\n');
const b64lines = buf => buf.toString('base64').match(/.{1,76}/g);
const marker = 'rem ---- ';

let head = read('install-strata-qwen.bat');
const cut = head.indexOf('\n' + marker);
if (cut >= 0) head = head.slice(0, cut + 1);
head = head.replace(/\n+$/, '\n');

const zip = 'qwen-skills-build.tmp.zip'; // relative: GNU tar reads 'C:' as a host name
if (fs.existsSync(zip)) fs.unlinkSync(zip);
execFileSync(process.env.SystemRoot + '/System32/tar.exe', ['-a', '-c', '-f', zip, '-C', 'qwen-skills', ...fs.readdirSync('qwen-skills')]);
const skills = b64lines(fs.readFileSync(zip));
fs.unlinkSync(zip);

const section = (what, prefix, ls) => marker + what + ': lines starting with "' + prefix + '" ----\n' + ls.map(l => prefix + l).join('\n') + '\n';

const out =
  head + '\n' +
  section('strata-qwen.bat', '::| ', lines('strata-qwen.bat')) +
  section('strata-hermes.bat', '::h ', lines('strata-hermes.bat')) +
  section('strata-download.bat', '::+ ', lines('strata-download.bat')) +
  section('qwen-skills.zip as base64', '::# ', skills) +
  section('qwen-settings.js as base64', '::~ ', b64lines(fs.readFileSync('qwen-settings.js')));

if (/[^\x00-\x7F]/.test(out)) throw new Error('installer must be ASCII only');
fs.writeFileSync('install-strata-qwen.bat', out.replace(/\n/g, '\r\n'));
console.log('ok: installer rebuilt (' + out.length + ' bytes)');
