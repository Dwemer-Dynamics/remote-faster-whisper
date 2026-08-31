#!/bin/bash

export PIP_NO_CACHE_DIR=1
export PIP_DISABLE_PIP_VERSION_CHECK=1

cd /home/dwemer/remote-faster-whisper/
python3 -m venv /home/dwemer/python-stt
source /home/dwemer/python-stt/bin/activate

echo "Install LocalWhisper, this may take a while."
python -m pip install --no-cache-dir -r requirements.txt

./conf.sh

