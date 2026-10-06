---
name: music-audio-tools
description: 音声の変換・切出し・結合・正規化を行う
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
    - 音声変換
    - mp3
    - 音声カット
    - 結合
    - ノーマライズ
    required_tools:
    - terminal
    optional_tools:
    - execute_code
    dependencies:
    - ffmpeg
    conflicts: []
    workflow: see '## Procedure'
    verification: ffprobe で出力の形式・長さが指定どおり
    fallback:
    - ffmpeg 不在は winget install Gyan.FFmpeg、または choco install ffmpeg
    - コピー結合で失敗するなら再エンコード(-c:a libmp3lame)
    - GUI は winget install Audacity.Audacity
    risk_level: low
    related:
    - audio-analysis
    - tts
    - video-frame-extraction
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# music-audio-tools

音声の変換・切出し・結合・正規化を行う

## When to Use
Trigger: 音声変換, mp3, 音声カット, 結合, ノーマライズ

## Tools
- required: terminal
- optional: execute_code
- dependencies: ffmpeg（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 変換: ffmpeg -i in.wav -b:a 192k out\out.mp3(出力は新規ディレクトリ)
2. 切出し: ffmpeg -ss 00:01:00 -to 00:02:30 -i in.mp3 -c copy out\clip.mp3
3. 結合: list.txt に file 'a.mp3' を並べ ffmpeg -f concat -safe 0 -i list.txt -c copy out\all.mp3
4. 音量: ffmpeg -i in -af loudnorm=I=-16 out\norm.wav

## Verification
ffprobe で出力の形式・長さが指定どおり

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. ffmpeg 不在は winget install Gyan.FFmpeg、または choco install ffmpeg
2. コピー結合で失敗するなら再エンコード(-c:a libmp3lame)
3. GUI は winget install Audacity.Audacity

## Related
audio-analysis, tts, video-frame-extraction

## Prohibited
- 元ファイルを上書きしない
- 著作権物の無断配布・加工公開をしない
- Approval 対象（permission-policy 参照）は実行前に確認する。
