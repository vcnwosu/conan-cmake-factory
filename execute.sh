#!/bin/bash
set -e

# 1. Install Dependencies
conan install . --output-folder=build --build=missing |& tee -a build/build.log

# 2. Configure CMake (using Conan toolchain)
cd build
cmake .. -DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake -DCMAKE_BUILD_TYPE=Release |& tee -a build.log

# 3. Build
cmake --build . |& tee -a build.log

# 4. Show Cache Stats (Proof of Optimization)
echo '--- Ccache Stats ---' |& tee -a build.log
ccache -s |& tee -a build.log
