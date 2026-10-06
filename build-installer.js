// Rebuilds the embedded payloads at the end of install-strata-qwen.bat:
//   "::| " lines = strata-qwen.bat, "::# " lines = qwen-skills/ as a base64 zip.
// Run after changing strata-qwen.bat or anything in qwen-skills/:  node build-installer.js
const fs = require('fs');
const os = require('os');
const path = require('path');
const { execFileSync } = require('child_process');

const read = f => fs.readFileSync(f, 'utf8').replace(/\r/g, '');
const marker = 'rem ---- ';

let head = read('install-strata-qwen.bat');
const cut = head.indexOf('\n' + marker);
if (cut >= 0) head = head.slice(0, cut + 1);
head = head.replace(/\n+$/, '\n');

const launcher = read('strata-qwen.bat').replace(/\n+$/, '').split('\n');

const zip = 'qwen-skills-build.tmp.zip'; // relative: GNU tar reads 'C:' as a host name
if (fs.existsSync(zip)) fs.unlinkSync(zip);
execFileSync(process.env.SystemRoot + '/System32/tar.exe', ['-a', '-c', '-f', zip, '-C', 'qwen-skills', ...fs.readdirSync('qwen-skills')]);
const b64 = fs.readFileSync(zip).toString('base64');
fs.unlinkSync(zip);
const chunks = b64.match(/.{1,76}/g);

const out =
  head +
  '\n' + marker + 'strata-qwen.bat: lines starting with "::| " (step 6 writes it out). Run "node build-installer.js" after changing it. ----\n' +
  launcher.map(l => '::| ' + l).join('\n') + '\n' +
  marker + 'qwen-skills.zip as base64: lines starting with "::# " (step 7 unpacks it). ----\n' +
  chunks.map(l => '::# ' + l).join('\n') + '\n';

if (/[^\x00-\x7F]/.test(out)) throw new Error('installer must be ASCII only');
fs.writeFileSync('install-strata-qwen.bat', out.replace(/\n/g, '\r\n'));
console.log('ok: launcher ' + launcher.length + ' lines, skills zip ' + chunks.length + ' lines');
