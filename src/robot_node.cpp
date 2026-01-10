#include <fmt/core.h>
#include <iostream>
#include <thread>
#include <chrono>

int main() {
    int sensor_id = 42;
    while(true) {
        // Use fmt library (requires Conan to fetch)
        fmt::print("[RobotNode] Reading Sensor #{}: OK\n", sensor_id);
        std::this_thread::sleep_for(std::chrono::seconds(1));
        break; // Run once for CI demo
    }
    return 0;
}
