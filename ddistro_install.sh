#!/bin/bash

export PIP_NO_CACHE_DIR=1
export PIP_DISABLE_PIP_VERSION_CHECK=1

cd /home/dwemer/remote-faster-whisper/
python3 -m venv /home/dwemer/python-stt
source /home/dwemer/python-stt/bin/activate

# Use DwemerDistro's validated CUDA selection; otherwise keep this environment CPU-only.
pytorch_gpu_available() {
  local cuda_home

  [ -r /var/lib/dwemerdistro/cuda-selection.env ] || return 1
  grep -qx 'CUDA_PYTORCH_SUPPORTED=1' /var/lib/dwemerdistro/cuda-selection.env || return 1
  cuda_home="$(sed -n 's|^CUDA_HOME=\(/usr/local/cuda-\(12\.8\|13\.0\)\)$|\1|p' /var/lib/dwemerdistro/cuda-selection.env | head -n 1)"
  [ -n "$cuda_home" ] && [ -x "$cuda_home/bin/nvcc" ]
}

echo "Install LocalWhisper, this may take a while."
if pytorch_gpu_available; then
  python -m pip install --no-cache-dir --upgrade torch --index-url https://download.pytorch.org/whl/cu128
else
  python -m pip install --no-cache-dir --upgrade torch --index-url https://download.pytorch.org/whl/cpu
fi
python -m pip install --no-cache-dir -r requirements.txt

./conf.sh

