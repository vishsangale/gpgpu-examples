#include <iostream>
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>

using namespace cv;

__global__ void color_to_greyscale(unsigned char* grayImage,
                                   unsigned char* rgbImage, int width,
                                   int height) {
    const int channels = 3;
    int x = threadIdx.x + blockIdx.x * blockDim.x;
    int y = threadIdx.y + blockIdx.y * blockDim.y;
    if (x < width && y < height) {
        int grayOffset = y * width + x;
        int rgbOffset = grayOffset * channels;
        unsigned char r = rgbImage[rgbOffset];
        unsigned char g = rgbImage[rgbOffset + 1];
        unsigned char b = rgbImage[rgbOffset + 2];
        grayImage[grayOffset] = 0.2126f * r + 0.7152f * g + 0.0722f * b;
    }
}

unsigned char* CopyArrayToGPU(unsigned char* HostArray, int NumElements) {
    int bytes = sizeof(unsigned char) * NumElements;
    unsigned char* DeviceArray;

    // Allocate memory on the GPU for array
    if (cudaMalloc(&DeviceArray, bytes) != cudaSuccess) {
        std::cout << "CopyArrayToGPU(): Couldn't allocate mem for array on GPU." << std::endl;
        return NULL;
    }

    // Copy the contents of the host array to the GPU
    if (cudaMemcpy(DeviceArray, HostArray, bytes, cudaMemcpyHostToDevice) !=
        cudaSuccess) {
        std::cout << "CopyArrayToGPU(): Couldn't copy host array to GPU." << std::endl;
        cudaFree(DeviceArray);
        return NULL;
    }

    return DeviceArray;
}

int main(int argc, char** argv) {
    Mat image;
    image = imread(argv[1], cv::IMREAD_COLOR);  // Read the file

    cv::cvtColor(image, image, cv::COLOR_BGR2RGB);

    if (!image.data)  // Check for invalid input
    {
        std::cout << "Could not open or find the image" << std::endl;
        return -1;
    }

    namedWindow("Display window",
                WINDOW_AUTOSIZE);     // Create a window for display.
    imshow("Display window", image);  // Show our image inside it.

    waitKey(0);

    const int width = image.cols;
    const int height = image.rows;
    unsigned char* color_array = image.ptr<unsigned char>();
    unsigned char* d_color_array = CopyArrayToGPU(color_array, image.elemSize());
    std::cout << "width " << width << ", height " << height << ", size " << image.size();
    unsigned char* grey_array = image.ptr<unsigned char>();
    unsigned char* d_grey_array = CopyArrayToGPU(grey_array, width * height);
    color_to_greyscale<<<1, 1>>>(d_grey_array, d_color_array, width, height);

    cudaDeviceSynchronize();
    unsigned char* conv_grey_array = image.ptr<unsigned char>();
    cudaMemcpy(conv_grey_array, d_grey_array, height * width * sizeof(unsigned char),
               cudaMemcpyDeviceToHost);
    cv::Mat grey_image(height, width, CV_8UC1);
    std::memcpy(grey_image.data, conv_grey_array,
                height * width * sizeof(unsigned char));

    imshow("Display window", grey_image);

    waitKey(0);

    cudaFree(d_color_array);
    cudaFree(d_grey_array);

    return 0;
}
