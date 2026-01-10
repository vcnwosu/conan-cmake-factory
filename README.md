# Conan CMake Factory

I've been developing a lot more interest in build systems and dependency managers, so I decided to play around with the C++ build ecosystem. The objective here is simple. Create a "Hermetic Build System" for a C++ application that manages dependencies via *Conan*, caches object files via *ccache*, and runs inside *Docker*.

## Prerequisites

- *Docker* installed
- *Python3* installed

## Tutorial Components

### The C++ Application

The `src/robot_node.cpp` contains some logic that mimics a robotics logging node. This is a simple, sample app for demonstration. One added thing is that it needs an external library `fmt`, which we will also use to demonstrate dependency mangement. This brings us to our next component.

### Conan Dependency Management

I've not delved too deeply in C++ dependency management before. Conan seemed interesting, particularly because it seemed flexible. Conan will help us manage the `fmt` dependency. The Configuration for Conan can be found in `conanfile.txt`. 

### The CMake Build System

CMake is an established industry standard for C and C++ projects. It's got a lot of support and documentation, so we'll use this as the backbone of our build ecosystem. Of course, as can be expected, we will have our build configuration in `CMakeLists.txt`.

### The Build Environment

Every build system needs to run in some preconfigured environment. Since this is only a simple project for tinkering and reproducibility, we will use Docker. This will encapsulate our toolchain. We will use a standard `Dockerfile` for this.

Can we consider it tinkering if we don't play around with optimizations? Of course, for CPU-intensive tasks like compilation, we want efficiency and we want to save time. Caching is usually our solution. I've found `ccache` rather helpful in the past, so we will use it here.

### The Pipeline

We're not here to tinker with Jenkins, GitLab, Bitbucket, etc, so let's keep the pipeline simple. Good old Bash scripting. The pipeline is implemented in `run_build.sh`.

## Steps to Execute

After cloning the repo, we simply run the pipeline script. It will build the Docker image (get our build environment/agent up and running) and then compile our sample app.

```bash
./run_build.sh
```

The goal, run it once and it builds successfully. Run it again, and we should get a cache hit, due to the `ccache -s` execution, and compilation should be practically instant.

Basically, the first time around, we should see this snippet in the output, showing the sample app getting compiled.

```
-- Generating done
-- Build files have been written to: /app/build
[ 50%] Building CXX object CMakeFiles/robot_node.dir/src/robot_node.cpp.o
[100%] Linking CXX executable robot_node
[100%] Built target robot_node
```

Then the second time, we should see the following, indicating Ccache prevented us from unnecessarily recompiling the sample app.

```
-- Build files have been written to: /app/build
Consolidate compiler generated dependencies of target robot_node
[100%] Built target robot_node
```

## Project structure

```tree
.
├── CMakeLists.txt
├── Dockerfile
├── README.md
├── conanfile.txt
├── run_build.sh
└── src
    └── robot_node.cpp

1 directory, 6 files
```

