---
name: speech-to-text
description: 音声を文字起こしする(Whisper 系)
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - multimodal
    category: multimodal
  kiridev:
    namespace: kiridev
    category: multimodal
    triggers:
    - 文字起こし
    - 音声認識
    - whisper
    - 書き起こし
    - STT
    required_tools:
    - terminal
    optional_tools:
    - write_file
    dependencies:
    - ffmpeg
    - faster-whisper
    - python
    conflicts: []
    workflow: see '## Procedure'
    verification: 文字起こし全長が音声長と対応し、サンプル箇所が音声と一致する
    fallback:
    - pip install faster-whisper が不可なら openai-whisper か whisper.cpp(main.exe -m ggml-small.bin)
    - CUDA 不可は device="cpu" と compute_type="int8"
    - ローカル不可はクラウド STT(機密でない場合のみ)
    risk_level: low
    related:
    - audio-analysis
    - video-analysis
    - tts
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# speech-to-text

音声を文字起こしする(Whisper 系)

## When to Use
Trigger: 文字起こし, 音声認識, whisper, 書き起こし, STT

## Tools
- required: terminal
- optional: write_file
- dependencies: ffmpeg, faster-whisper, python（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. ffmpeg -i <in> -ar 16000 -ac 1 work\audio.wav で正規化する
2. faster-whisper: python -c で WhisperModel("small", device="cuda" or "cpu").transcribe(wav, language="ja")
3. セグメントを時刻付きで transcripts\<name>.txt/.srt に保存する
4. 固有名詞・数値を音声と突き合わせ要確認箇所を印付けする

## Verification
文字起こし全長が音声長と対応し、サンプル箇所が音声と一致する

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. pip install faster-whisper が不可なら openai-whisper か whisper.cpp(main.exe -m ggml-small.bin)
2. CUDA 不可は device="cpu" と compute_type="int8"
3. ローカル不可はクラウド STT(機密でない場合のみ)

## Related
audio-analysis, video-analysis, tts

## Prohibited
- 機密音声を外部 STT へ承認なしで送らない
- 無断録音の文字起こしを行わない
- Approval 対象（permission-policy 参照）は実行前に確認する。
