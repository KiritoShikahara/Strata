---
name: video-frame-extraction
description: 動画から代表フレームや連番画像を抽出する
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
    - フレーム抽出
    - サムネイル
    - 連番画像
    - ffmpeg frames
    required_tools:
    - terminal
    optional_tools:
    - vision_analyze
    dependencies:
    - ffmpeg
    conflicts: []
    workflow: see '## Procedure'
    verification: (Get-ChildItem frames\<name>).Count が想定枚数と一致する
    fallback:
    - ffmpeg 不在は winget install Gyan.FFmpeg
    - ffmpeg 不可は python -m pip install opencv-python で cv2.VideoCapture
    - ディスク消費大なら fps を下げるか JPEG(-q:v 3)
    risk_level: low
    related:
    - video-analysis
    - image-analysis
    - music-audio-tools
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# video-frame-extraction

動画から代表フレームや連番画像を抽出する

## When to Use
Trigger: フレーム抽出, サムネイル, 連番画像, ffmpeg frames

## Tools
- required: terminal
- optional: vision_analyze
- dependencies: ffmpeg（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 出力用の空ディレクトリを作る: New-Item -ItemType Directory frames\<name>
2. 等間隔: ffmpeg -i <video> -vf fps=1 frames\<name>\f_%04d.png
3. 場面転換: ffmpeg -i <video> -vf "select=gt(scene\,0.4)" -vsync vfr frames\<name>\s_%04d.png
4. 特定時刻: ffmpeg -ss 00:00:30 -i <video> -frames:v 1 out.png
5. 枚数を数え、代表フレームを vision_analyze で確認

## Verification
(Get-ChildItem frames\<name>).Count が想定枚数と一致する

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. ffmpeg 不在は winget install Gyan.FFmpeg
2. ffmpeg 不可は python -m pip install opencv-python で cv2.VideoCapture
3. ディスク消費大なら fps を下げるか JPEG(-q:v 3)

## Related
video-analysis, image-analysis, music-audio-tools

## Prohibited
- 既存ディレクトリのファイルを上書き・大量削除しない
- 機密動画のフレームを外部送信しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
