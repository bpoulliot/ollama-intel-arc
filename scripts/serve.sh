#!/bin/sh

source /opt/intel/oneapi/setvars.sh
export USE_XETLA=OFF
export ZES_ENABLE_SYSMAN=1
export SYCL_CACHE_PERSISTENT=1
export SYCL_PI_LEVEL_ZERO_USE_IMMEDIATE_COMMANDLISTS=1
export ONEAPI_DEVICE_SELECTOR=level_zero:0

/usr/local/lib/python3.12/dist-packages/bigdl/cpp/libs/ollama serve
