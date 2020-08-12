cmake_minimum_required(VERSION 3.10)

include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
conan_basic_setup(TARGETS)

add_subdirectory(addition)
add_subdirectory(color-to-grey)
