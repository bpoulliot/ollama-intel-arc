FROM intel/intel-extension-for-pytorch:2.7.10-xpu

# optional, might help with memory allocation performance and scalability
RUN apt-get update && \
    apt-get install -y --no-install-recommends --fix-missing libjemalloc-dev
ENV LD_PRELOAD=libjemalloc.so.2

# git clone and run sdnext
RUN echo '#!/bin/bash\ngit status || git clone https://github.com/comfyanonymous/ComfyUI.git /app \npip install -r /app/requirements.txt \npython /app/main.py "$@"' | tee /bin/startup.sh
RUN chmod 755 /bin/startup.sh

# actually run sdnext
WORKDIR /app
ENTRYPOINT [ "startup.sh", "--highvram", "--use-pytorch-cross-attention", "--listen=0.0.0.0", "--port=8188" ]

# stop signal
STOPSIGNAL SIGINT
