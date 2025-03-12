#!/bin/sh

cd /llm/scripts/
source ipex-llm-init --gpu --device Arc

bash start-ollama.sh

tail -f /dev/null
