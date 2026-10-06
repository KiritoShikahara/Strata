---
name: 3d-pipeline
description: 3D 制作パイプライン（モデリング〜エンジン組込）設計
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
    - 3D パイプライン
    - モデリング
    - リトポ
    - UV
    - ベイク
    - glTF
    - FBX
    required_tools:
    - terminal
    - read_file
    - write_file
    optional_tools:
    - vision_analyze
    dependencies:
    - blender
    conflicts: []
    workflow: see '## Procedure'
    verification: エンジン上で実寸・法線・マテリアルが正しく、トライ数が予算内
    fallback:
    - winget install BlenderFoundation.Blender で導入
    - FBX 不具合は glTF/USD に切替
    - 自動化不可なら手順書付きで手動書き出しする
    risk_level: low
    related:
    - blender-assist
    - asset-pipeline
    - asset-generation
    - unity
    - unreal-engine
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# 3d-pipeline

3D 制作パイプライン（モデリング〜エンジン組込）設計

## When to Use
Trigger: 3D パイプライン, モデリング, リトポ, UV, ベイク, glTF, FBX

## Tools
- required: terminal, read_file, write_file
- optional: vision_analyze
- dependencies: blender（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 工程を決める: ブロックアウト → ハイポリ → リトポ → UV → ベイク → テクスチャ → リグ → 書き出し
2. スケール（1 unit=1m）・軸・命名・トライ予算を文書化する
3. UV は重なり無し・テクセル密度統一、法線/AO/曲率をベイクする
4. blender -b model.blend -P export.py で FBX/glTF を一括書き出しする
5. Unity/Unreal へインポートしスケール・マテリアル・LOD を確認する

## Verification
エンジン上で実寸・法線・マテリアルが正しく、トライ数が予算内

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. winget install BlenderFoundation.Blender で導入
2. FBX 不具合は glTF/USD に切替
3. 自動化不可なら手順書付きで手動書き出しする

## Related
blender-assist, asset-pipeline, asset-generation, unity, unreal-engine

## Prohibited
- ソース .blend を上書き/削除しない（出力は別ディレクトリ）
- ライセンス不明のモデルを同梱しない。有償アセット購入は承認が必要
- Approval 対象（permission-policy 参照）は実行前に確認する。
