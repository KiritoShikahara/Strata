// Merges the Strata settings into ~/.qwen/settings.json (existing keys are kept).
// Goal: Qwen Code keeps working forever - old context is summarized (auto-compaction) instead of stopping.
// The installer embeds this file and runs it; run "node build-installer.js" after changing it.
const fs = require('fs');
const os = require('os');
const path = require('path');

const MODEL_ID = 'strata'; // strata-qwen.bat sets OPENAI_MODEL=strata; the server accepts any model name
const file = path.join(os.homedir(), '.qwen', 'settings.json');

let s = {};
if (fs.existsSync(file)) {
  try {
    s = JSON.parse(fs.readFileSync(file, 'utf8').replace(/^﻿/, ''));
  } catch (e) {
    fs.copyFileSync(file, file + '.bak');
    console.log('settings.json was not valid JSON; kept a copy as settings.json.bak');
  }
}

const obj = (o, k) => (o[k] && typeof o[k] === 'object' && !Array.isArray(o[k]) ? o[k] : (o[k] = {}));

// never stop on turn / token limits
const model = obj(s, 'model');
model.maxSessionTurns = -1;
model.sessionTokenLimit = -1;

// summarize old context earlier than the default 85%, so the 131072-token window is never hit
obj(s, 'context').autoCompactThreshold = 0.7;

// tell Qwen Code the real window of the Strata model (131072 tokens, a little less for safety)
const openai = (obj(s, 'modelProviders').openai = Array.isArray(obj(s, 'modelProviders').openai) ? s.modelProviders.openai : []);
const entry = {
  id: MODEL_ID,
  name: 'Strata (local)',
  envKey: 'OPENAI_API_KEY',
  baseUrl: 'http://127.0.0.1:8080/v1',
  generationConfig: {
    timeout: 900000,
    streamIdleTimeoutMs: 900000,
    maxRetries: 2,
    contextWindowSize: 120000,
    samplingParams: { max_tokens: 8192 },
  },
};
const i = openai.findIndex(m => m && m.id === MODEL_ID);
if (i >= 0) openai[i] = entry; else openai.push(entry);

fs.mkdirSync(path.dirname(file), { recursive: true });
fs.writeFileSync(file, JSON.stringify(s, null, 2) + '\n');
console.log('wrote ' + file);
