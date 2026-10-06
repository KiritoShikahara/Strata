---
name: gpu-nvidia
description: NVIDIA GPU の状態確認とドライバ/CUDA 診断
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - system
    category: system
  kiridev:
    namespace: kiridev
    category: system
    triggers:
    - NVIDIA
    - GPU
    - nvidia-smi
    - CUDA
    - VRAM
    required_tools:
    - terminal
    optional_tools: []
    dependencies:
    - nvidia-smi
    conflicts: []
    workflow: see '## Procedure'
    verification: nvidia-smi が正常終了し期待 GPU・ドライバ版を表示
    fallback:
    - 'nvidia-smi 不在: C:\Windows\System32\nvidia-smi.exe か NVSMI フォルダを確認'
    - Get-CimInstance Win32_VideoController で認識確認
    - GeForce Experience / 公式ドライバ導入を案内(承認後)
    - dxdiag /t で情報取得
    risk_level: low
    related:
    - hardware-diagnostics
    - graphics-debugging
    - system-monitoring
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# gpu-nvidia

NVIDIA GPU の状態確認とドライバ/CUDA 診断

## When to Use
Trigger: NVIDIA, GPU, nvidia-smi, CUDA, VRAM

## Tools
- required: terminal
- optional: -
- dependencies: nvidia-smi（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. nvidia-smi で GPU/ドライバ/CUDA 版と VRAM 使用量を確認する
2. nvidia-smi --query-gpu=name,temperature.gpu,utilization.gpu,memory.used,memory.total --format=csv -l 2
3. nvidia-smi --query-compute-apps=pid,name,used_memory --format=csv でプロセス別使用を見る
4. nvcc --version と python -c "import torch;print(torch.cuda.is_available())" で CUDA を確認する
5. WDDM TDR 疑いは System ログの nvlddmkm イベントを確認する

## Verification
nvidia-smi が正常終了し期待 GPU・ドライバ版を表示

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. nvidia-smi 不在: C:\Windows\System32\nvidia-smi.exe か NVSMI フォルダを確認
2. Get-CimInstance Win32_VideoController で認識確認
3. GeForce Experience / 公式ドライバ導入を案内(承認後)
4. dxdiag /t で情報取得

## Related
hardware-diagnostics, graphics-debugging, system-monitoring

## Prohibited
- ドライバ導入/ロールバック/クロック設定変更を承認なしで行わない
- ユーザーのプロセスを GPU 解放のため勝手に kill しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
