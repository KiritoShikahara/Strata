---
name: blender-assist
description: Blender のスクリプト・バッチ処理・レンダ支援
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - creative
    category: creative
  kiridev:
    namespace: kiridev
    category: creative
    triggers:
    - Blender
    - bpy
    - レンダリング
    - モディファイア
    - blender -b
    required_tools:
    - terminal
    - write_file
    - read_file
    optional_tools:
    - vision_analyze
    dependencies:
    - blender
    conflicts: []
    workflow: see '## Procedure'
    verification: スクリプトが終了コード 0 で完了し、出力ファイルが期待した内容で生成されている
    fallback:
    - winget install BlenderFoundation.Blender で導入、または portable zip を展開
    - GPU レンダ不可は --cycles-device CPU に切替
    - bpy 不可は pip install bpy（Python 版）か GUI 手順を案内
    risk_level: low
    related:
    - 3d-pipeline
    - asset-generation
    - asset-pipeline
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# blender-assist

Blender のスクリプト・バッチ処理・レンダ支援

## When to Use
Trigger: Blender, bpy, レンダリング, モディファイア, blender -b

## Tools
- required: terminal, write_file, read_file
- optional: vision_analyze
- dependencies: blender（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. Get-Command blender か既定パス（C:\Program Files\Blender Foundation\）を確認し blender --version を実行する
2. bpy スクリプトを作成し blender -b scene.blend -P script.py -- <args> でヘッドレス実行する
3. レンダは blender -b scene.blend -o //out\frame_#### -F PNG -f 1（または -a）で出力する
4. モディファイア/マテリアル操作は bpy.data を読み、変更前に別名保存（bpy.ops.wm.save_as_mainfile(copy=True)）する
5. 出力画像を vision_analyze で確認し、設定（サンプル数/解像度）を調整する

## Verification
スクリプトが終了コード 0 で完了し、出力ファイルが期待した内容で生成されている

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. winget install BlenderFoundation.Blender で導入、または portable zip を展開
2. GPU レンダ不可は --cycles-device CPU に切替
3. bpy 不可は pip install bpy（Python 版）か GUI 手順を案内

## Related
3d-pipeline, asset-generation, asset-pipeline

## Prohibited
- 元 .blend の無断上書き・大量レンダ出力の既存ファイル削除をしない
- 未確認の外部アドオン/スクリプトを実行しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
