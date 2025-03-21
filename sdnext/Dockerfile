FROM intel/intel-extension-for-pytorch:2.6.10-xpu

# set paths to use with sdnext
ENV SD_DATADIR="/mnt/data"
ENV SD_MODELSDIR="/mnt/models"

# git clone and start sdnext
RUN echo '#!/bin/bash\ngit status || git clone https://github.com/vladmandic/sdnext.git .\npython /app/launch.py "$@"' | tee /bin/startup.sh
RUN chmod 755 /bin/startup.sh

# run sdnext
WORKDIR /app
ENTRYPOINT [ "startup.sh", "-f", "--use-ipex", "--uv", "--listen", "--debug", "--api-log", "--log", "sdnext.log" ]

# stop signal
STOPSIGNAL SIGINT
