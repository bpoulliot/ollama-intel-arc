FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PIP_BREAK_SYSTEM_PACKAGES=1
ENV OLLAMA_NUM_GPU=999
ENV OLLAMA_HOST=0.0.0.0:11434

# Install base packages
RUN apt update && \
    apt install --no-install-recommends -q -y \
    wget \
    gnupg \
    ca-certificates \
    python3-pip \
    pkg-config \
    build-essential \
    python3-dev \
    cmake

# Install Client GPUs
# Reference: https://dgpu-docs.intel.com/driver/client/overview.html#installing-client-gpus-on-ubuntu-desktop-24-04-lts
RUN wget -qO - https://repositories.intel.com/gpu/intel-graphics.key | \
    gpg --yes --dearmor --output /usr/share/keyrings/intel-graphics.gpg && \
    echo "deb [arch=amd64,i386 signed-by=/usr/share/keyrings/intel-graphics.gpg] https://repositories.intel.com/gpu/ubuntu noble unified" | \
    tee /etc/apt/sources.list.d/intel-gpu-noble.list && \
    apt update && \
    apt install -y libze-intel-gpu1 libze1 intel-opencl-icd clinfo intel-gsc && \
    apt install -y libze-dev intel-ocloc && \
    apt install --no-install-recommends -q -y \
    udev \
    level-zero \
    libigdgmm12

# Install oneAPI Base Toolkit
# Reference: https://www.intel.com/content/www/us/en/developer/tools/oneapi/base-toolkit-download.html?packages=oneapi-toolkit&oneapi-toolkit-os=linux&oneapi-lin=apt
RUN apt update && \
    apt install -y gpg-agent wget && \
    wget -O- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB | \
    gpg --dearmor | tee /usr/share/keyrings/oneapi-archive-keyring.gpg > /dev/null && \
    echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" |  \
    tee /etc/apt/sources.list.d/oneAPI.list && \
    apt update && \
    apt install -y intel-oneapi-base-toolkit

# Install serve.sh script
COPY ./scripts/serve.sh /usr/share/lib/serve.sh

# Install ipex-llm[cpp] using pip
# Reference: https://github.com/intel/ipex-llm/blob/main/docs/mddocs/Quickstart/llama_cpp_quickstart.md#1-install-ipex-llm-for-llamacpp
RUN pip install --pre --upgrade ipex-llm[cpp]

# Set entrypoint to run the serve.sh script
ENTRYPOINT ["/bin/bash", "/usr/share/lib/serve.sh"]
