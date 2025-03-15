FROM intel/intel-extension-for-pytorch:2.6.10-xpu

# essentials
RUN apt-get update && \
    apt-get install -y --no-install-recommends --fix-missing \
    software-properties-common \
    build-essential \
    ca-certificates \
    wget \
    gpg \
    git

# python3.10
RUN apt-get install -y --no-install-recommends --fix-missing python3.10-venv

# jemalloc is not required but it is highly recommended (also used with optional ipexrun)
RUN apt-get install -y --no-install-recommends --fix-missing libjemalloc-dev
ENV LD_PRELOAD=libjemalloc.so.2

# cleanup
RUN /usr/sbin/ldconfig
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# stop pip and uv from caching
ENV PIP_NO_CACHE_DIR=true
ENV UV_NO_CACHE=true

# set paths to use with sdnext
ENV SD_DOCKER=true
ENV SD_DATADIR="/mnt/data"
ENV SD_MODELSDIR="/mnt/models"
ENV venv_dir="/mnt/python/venv"

# git clone and start sdnext
RUN echo '#!/bin/bash\ngit status || git clone https://github.com/vladmandic/sdnext.git .\n/app/webui.sh "$@"' | tee /bin/startup.sh
RUN chmod 755 /bin/startup.sh

# run sdnext
WORKDIR /app
ENTRYPOINT [ "startup.sh", "-f", "--use-ipex", "--uv", "--listen", "--debug", "--api-log", "--log", "sdnext.log" ]

# expose port
EXPOSE 7860

# stop signal
STOPSIGNAL SIGINT
