---
name: audio-analysis
description: 音声ファイルの特徴・内容・メタ情報を解析する
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
    - 音声解析
    - 音声ファイル
    - ffprobe
    - 波形
    - 無音検出
    required_tools:
    - terminal
    optional_tools:
    - execute_code
    dependencies:
    - ffmpeg
    - ffprobe
    conflicts: []
    workflow: see '## Procedure'
    verification: ffprobe の長さ・形式が結果に記載され、検出値が出力に残っている
    fallback:
    - ffmpeg 不在は Get-Command ffmpeg -> winget install Gyan.FFmpeg
    - 詳細解析は pip install librosa で実行
    - WSL の sox を代替に使う
    risk_level: low
    related:
    - speech-to-text
    - music-audio-tools
    - video-analysis
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# audio-analysis

音声ファイルの特徴・内容・メタ情報を解析する

## When to Use
Trigger: 音声解析, 音声ファイル, ffprobe, 波形, 無音検出

## Tools
- required: terminal
- optional: execute_code
- dependencies: ffmpeg, ffprobe（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. ffprobe -v error -show_format -show_streams <audio> でコーデック・長さ・サンプルレート確認
2. 音量: ffmpeg -i <f> -af volumedetect -f null NUL
3. 無音区間: ffmpeg -i <f> -af silencedetect=n=-30dB:d=0.5 -f null NUL
4. 内容把握が必要なら speech-to-text で文字起こしして要約

## Verification
ffprobe の長さ・形式が結果に記載され、検出値が出力に残っている

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. ffmpeg 不在は Get-Command ffmpeg -> winget install Gyan.FFmpeg
2. 詳細解析は pip install librosa で実行
3. WSL の sox を代替に使う

## Related
speech-to-text, music-audio-tools, video-analysis

## Prohibited
- 他人の音声から個人を特定しない
- 元ファイルを上書きしない
- Approval 対象（permission-policy 参照）は実行前に確認する。
