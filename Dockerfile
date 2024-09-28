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

# Install IPEX-LLM on Linux with Intel GPU
RUN wget -qO - https://repositories.intel.com/gpu/intel-graphics.key | \
    gpg --dearmor --output /usr/share/keyrings/intel-graphics.gpg && \
    echo "deb [arch=amd64,i386 signed-by=/usr/share/keyrings/intel-graphics.gpg] https://repositories.intel.com/gpu/ubuntu jammy client" | \
    tee /etc/apt/sources.list.d/intel-gpu-jammy.list && \
    apt update && \
    apt install --no-install-recommends -q -y \
    udev \
    level-zero \
    libigdgmm12 \
    intel-level-zero-gpu \
    intel-opencl-icd

# Install OneAPI packages
RUN wget -qO - https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB | \
    gpg --dearmor --output /usr/share/keyrings/oneapi-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" | \
    tee /etc/apt/sources.list.d/oneAPI.list && \
    apt update && \
    apt install --no-install-recommends -q -y \
    intel-oneapi-common-vars \
    intel-oneapi-common-oneapi-vars \
    intel-oneapi-diagnostics-utility \
    intel-oneapi-compiler-dpcpp-cpp \
    intel-oneapi-dpcpp-ct \
    intel-oneapi-mkl \
    intel-oneapi-mkl-devel \
    intel-oneapi-mpi \
    intel-oneapi-mpi-devel \
    intel-oneapi-dal \
    intel-oneapi-dal-devel \
    intel-oneapi-ippcp \
    intel-oneapi-ippcp-devel \
    intel-oneapi-ipp \
    intel-oneapi-ipp-devel \
    intel-oneapi-tlt \
    intel-oneapi-ccl \
    intel-oneapi-ccl-devel \
    intel-oneapi-dnnl-devel \
    intel-oneapi-dnnl \
    intel-oneapi-tcm-1.0

# Install serve.sh script
COPY ./scripts/serve.sh /usr/share/lib/serve.sh

# Install ipex-llm[cpp] using pip
RUN pip install --pre --upgrade ipex-llm[cpp]

# Set entrypoint to run the serve.sh script
ENTRYPOINT ["/bin/bash", "/usr/share/lib/serve.sh"]
