cmake_minimum_required(VERSION 3.10)

set(NAME color-to-grey)

find_package(opencv REQUIRED)

project(${NAME} LANGUAGES CUDA CXX)

set(CMAKE_CUDA_STANDARD 14)
set(CMAKE_CUDA_STANDARD_REQUIRED ON)

add_executable(${NAME} color-to-gray.cu)

set_target_properties(${NAME} PROPERTIES CUDA_SEPERABLE_COMPILATION ON)

target_link_libraries(${NAME} CONAN_LIB::opencv_opencv_core CONAN_PKG::opencv)

