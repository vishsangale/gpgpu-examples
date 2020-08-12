from conans import ConanFile, CMake

class GPGPUConan(ConanFile):
    settings = "os", "compiler", "build_type", "arch"
    requires = "opencv/4.3.0@conan/stable"
    generators = "cmake", "gcc", "cmake_find_package", "virtualrunenv"
    default_options = {"*:shared": True}


    def build(self):
        cmake = CMake(self)
        cmake.configure()
        cmake.build()
