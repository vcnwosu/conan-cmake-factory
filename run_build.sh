#!/bin/bash
set -e

# create local cache dirs to persist between runs
mkdir -p $(pwd)/cache
mkdir -p $(pwd)/build

echo "🚀 Building Docker Build Environment..."
docker build -t robotics-builder .

echo "🔧 Running Build..."
docker run --rm \
    -v $(pwd):/app \
    -v $(pwd)/cache:/cache \
    robotics-builder /bin/bash -c "
        # 1. Install Dependencies
        conan install . --output-folder=build --build=missing
        
        # 2. Configure CMake (using Conan toolchain)
        cd build
        cmake .. -DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake -DCMAKE_BUILD_TYPE=Release
        
        # 3. Build
        cmake --build .
        
        # 4. Show Cache Stats (Proof of Optimization)
        echo '--- Ccache Stats ---'
        ccache -s
    "
