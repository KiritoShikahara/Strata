---
name: video-analysis
description: 動画の内容・構成・音声を解析して要約する
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
    - 動画解析
    - 動画要約
    - video analyze
    - 動画を見て
    required_tools:
    - video_analyze
    optional_tools:
    - terminal
    - vision_analyze
    dependencies:
    - ffmpeg
    - ffprobe
    conflicts: []
    workflow: see '## Procedure'
    verification: 要約の主要シーンに時刻があり、フレーム/音声で裏取りされている
    fallback:
    - video_analyze 不可は 1〜5 秒間隔でフレーム抽出し vision_analyze で個別解析
    - ffmpeg 不在は winget install Gyan.FFmpeg
    - 大容量は 720p に縮小して再投入
    risk_level: low
    related:
    - video-frame-extraction
    - speech-to-text
    - vision
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# video-analysis

動画の内容・構成・音声を解析して要約する

## When to Use
Trigger: 動画解析, 動画要約, video analyze, 動画を見て

## Tools
- required: video_analyze
- optional: terminal, vision_analyze
- dependencies: ffmpeg, ffprobe（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. ffprobe -v error -show_format -show_streams <video> で長さ・解像度・fps を確認
2. video_analyze に動画と質問を渡し、長尺は区間分割(ffmpeg -ss/-t)して解析
3. 映像は video-frame-extraction、音声は speech-to-text で補完する
4. 時刻付きタイムラインで要約する

## Verification
要約の主要シーンに時刻があり、フレーム/音声で裏取りされている

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. video_analyze 不可は 1〜5 秒間隔でフレーム抽出し vision_analyze で個別解析
2. ffmpeg 不在は winget install Gyan.FFmpeg
3. 大容量は 720p に縮小して再投入

## Related
video-frame-extraction, speech-to-text, vision

## Prohibited
- 機密動画を外部 provider へ承認なしで送らない
- 映像内人物の特定をしない
- Approval 対象（permission-policy 参照）は実行前に確認する。
