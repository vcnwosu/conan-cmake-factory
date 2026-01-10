cmake_minimum_required(VERSION 3.15)
project(RobotNode CXX)

# 1. Integration with Conan
find_package(fmt REQUIRED)

# 2. Integration with ccache (Build Optimization)
find_program(CCACHE_PROGRAM ccache)
if(CCACHE_PROGRAM)
    set(CMAKE_CXX_COMPILER_LAUNCHER "${CCACHE_PROGRAM}")
endif()

add_executable(robot_node src/robot_node.cpp)
target_link_libraries(robot_node PRIVATE fmt::fmt)
