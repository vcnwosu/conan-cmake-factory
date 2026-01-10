FROM ubuntu:22.04

# 1. Install Toolchain
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    python3-pip \
    ccache \
    git \
    && rm -rf /var/lib/apt/lists/*

# 2. Install Conan (The Package Manager)
RUN pip3 install conan && conan profile detect

# 3. Setup Ccache (Optimization)
# Point ccache to a directory we will mount as a volume
ENV CCACHE_DIR=/cache
ENV CCACHE_MAXSIZE=5G

WORKDIR /app
