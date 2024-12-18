# Start with a base Ubuntu image
FROM ubuntu:18.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/usr/local/cuda/bin:${PATH}"
ENV LD_LIBRARY_PATH="/usr/local/cuda/lib64:${LD_LIBRARY_PATH}"

# Install prerequisites
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    gnupg \
    software-properties-common \
    build-essential \
    python3.8 \
    python3.8-dev \
    python3.8-distutils \
    python3-pip \
    zlib1g-dev \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    libopenjp2-7-dev \
    libwebp-dev \
    libx11-dev \
    libgl1-mesa-glx \
    libegl1-mesa \
    libxrandr-dev \
    libxss-dev \
    libxcursor-dev \
    libxi-dev \
    libxtst-dev \
    libffi-dev \
    gcc \
    g++ \
    make

# Add the CUDA repository pin
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin && \
    mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600

# Download and install the CUDA 10.2 local repository package
RUN wget https://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb && \
    dpkg -i cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb && \
    apt-key add /var/cuda-repo-10-2-local-10.2.89-440.33.01/7fa2af80.pub && \
    apt-get update

# Install CUDA 10.2
RUN apt-get install -y cuda

# Add the toolchain repository for GCC 8
RUN add-apt-repository ppa:ubuntu-toolchain-r/test && apt-get update && apt-get install -y \
    gcc-8 g++-8

# Set GCC 8 as the default
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 100 && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-8 100

# Update the default Python to Python 3.8
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1 && \
    update-alternatives --set python3 /usr/bin/python3.8

# Upgrade pip and install necessary Python packages
RUN python3 -m pip install --upgrade pip && \
    pip3 install --no-cache-dir \
    setuptools \
    wheel \
    numpy \
    Cython \
    pillow

# Install PyTorch and related packages
RUN pip3 install --no-cache-dir \
    torch==1.9.1+cu111 \
    torchvision==0.10.1+cu111 \
    torchaudio==0.9.1 -f https://download.pytorch.org/whl/torch_stable.html

WORKDIR /datasetdm
RUN apt-get install git -y
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN pip install --upgrade pip==20.3

COPY . .
RUN pip install setuptools==59.5.0
RUN pip install -r requirements.txt


ENV PYTHONPATH=/datasetdm:$PYTHONPATH
# Set default command
CMD ["bash"]

