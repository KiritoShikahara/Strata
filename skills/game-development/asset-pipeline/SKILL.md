---
name: asset-pipeline
description: テクスチャ・モデル・音声のインポート/最適化パイプライン
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - game-development
    category: game-development
  kiridev:
    namespace: kiridev
    category: game-development
    triggers:
    - アセット
    - インポート設定
    - FBX
    - テクスチャ圧縮
    - LOD
    - パイプライン
    required_tools:
    - terminal
    - read_file
    - write_file
    optional_tools:
    - search_files
    dependencies:
    - ffmpeg
    - ImageMagick
    conflicts: []
    workflow: see '## Procedure'
    verification: Get-ChildItem でサイズ予算内であり、Editor で警告なくインポートされ見た目が正しい
    fallback:
    - winget install Gyan.FFmpeg / ImageMagick.ImageMagick で導入
    - Blender CLI（blender -b -P script.py）で一括変換
    - バッチ失敗分は個別に Editor で再インポート
    risk_level: low
    related:
    - unity
    - unreal-engine
    - blender-assist
    - 3d-pipeline
    - git
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# asset-pipeline

テクスチャ・モデル・音声のインポート/最適化パイプライン

## When to Use
Trigger: アセット, インポート設定, FBX, テクスチャ圧縮, LOD, パイプライン

## Tools
- required: terminal, read_file, write_file
- optional: search_files
- dependencies: ffmpeg, ImageMagick（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 命名規則とフォルダ構成（Art\Source と Assets\Art）を決めソースを分離管理する
2. FBX/glTF のスケール・軸・単位とテクスチャ解像度（2 の累乗）を統一する
3. 画像は magick mogrify、音声は ffmpeg -i in.wav -c:a libvorbis out.ogg で変換する
4. Unity は Import Settings/Preset、Unreal は Import 設定とテクスチャグループで圧縮・LOD を設定する
5. 大容量バイナリは Git LFS（git lfs track "*.psd"）で管理しサイズレポートを出す

## Verification
Get-ChildItem でサイズ予算内であり、Editor で警告なくインポートされ見た目が正しい

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. winget install Gyan.FFmpeg / ImageMagick.ImageMagick で導入
2. Blender CLI（blender -b -P script.py）で一括変換
3. バッチ失敗分は個別に Editor で再インポート

## Related
unity, unreal-engine, blender-assist, 3d-pipeline, git

## Prohibited
- ソース素材を上書き/削除しない（変換は別ディレクトリに出力）
- 著作権・ライセンス不明の素材を同梱しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
