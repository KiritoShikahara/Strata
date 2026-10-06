---
name: tts
description: テキストを音声合成して音声ファイルを作る
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
    - 読み上げ
    - 音声合成
    - TTS
    - ナレーション
    required_tools:
    - text_to_speech
    optional_tools:
    - terminal
    - write_file
    dependencies:
    - ffmpeg
    conflicts: []
    workflow: see '## Procedure'
    verification: 音声ファイルが生成され、ffprobe の長さが想定範囲内
    fallback:
    - 'provider 不可は Windows 標準: System.Speech.Synthesis.SpeechSynthesizer(PowerShell)'
    - 高品質ローカルは piper-tts / VOICEVOX(:50021)を利用
    - ffmpeg 不在は winget install Gyan.FFmpeg
    risk_level: low
    related:
    - speech-to-text
    - music-audio-tools
    - audio-analysis
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# tts

テキストを音声合成して音声ファイルを作る

## When to Use
Trigger: 読み上げ, 音声合成, TTS, ナレーション

## Tools
- required: text_to_speech
- optional: terminal, write_file
- dependencies: ffmpeg（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 読み上げ原稿を整形(数式・URL・英略語に読み仮名)する
2. text_to_speech で生成し outputs\audio\ に保存する
3. ffprobe で長さを確認し、必要なら ffmpeg で mp3/wav 変換・音量正規化
4. 聞き取りにくい箇所は原稿を修正して再生成する

## Verification
音声ファイルが生成され、ffprobe の長さが想定範囲内

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. provider 不可は Windows 標準: System.Speech.Synthesis.SpeechSynthesizer(PowerShell)
2. 高品質ローカルは piper-tts / VOICEVOX(:50021)を利用
3. ffmpeg 不在は winget install Gyan.FFmpeg

## Related
speech-to-text, music-audio-tools, audio-analysis

## Prohibited
- 実在人物の声のなりすましをしない
- 有料 TTS の大量生成を承認なしで行わない
- Approval 対象（permission-policy 参照）は実行前に確認する。
