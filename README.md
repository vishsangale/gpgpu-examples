Dump of simple GPGPU examples.

Some basic commands used
```
mkdir build && cd build

cmake ..

cmake --build . --config Release

./addition


# For profiling

nvprof ./addition
```

Output of profiling on M4000 GPU

```
==3614== NVPROF is profiling process 3614, command: ./addition
Max error: 0
==3614== Profiling application: ./addition
==3614== Profiling result:
            Type  Time(%)      Time     Calls       Avg       Min       Max  Name
 GPU activities:  100.00%  177.84us         1  177.84us  177.84us  177.84us  add(int, float*, float*)
      API calls:   98.17%  145.24ms         2  72.618ms  439.40us  144.80ms  cudaMallocManaged
                    0.82%  1.2105ms         1  1.2105ms  1.2105ms  1.2105ms  cudaLaunchKernel
                    0.47%  695.25us         2  347.63us  311.77us  383.48us  cudaFree
                    0.23%  346.03us        97  3.5670us     249ns  199.01us  cuDeviceGetAttribute
                    0.13%  188.94us         1  188.94us  188.94us  188.94us  cuDeviceTotalMem
                    0.13%  185.50us         1  185.50us  185.50us  185.50us  cudaDeviceSynchronize
                    0.05%  67.443us         1  67.443us  67.443us  67.443us  cuDeviceGetName
                    0.00%  4.3940us         1  4.3940us  4.3940us  4.3940us  cuDeviceGetPCIBusId
                    0.00%  2.9580us         3     986ns     263ns  2.2790us  cuDeviceGetCount
                    0.00%  1.2890us         2     644ns     266ns  1.0230us  cuDeviceGet
                    0.00%     426ns         1     426ns     426ns     426ns  cuDeviceGetUuid

==3614== Unified Memory profiling result:
Device "Quadro M1200 (0)"
   Count  Avg Size  Min Size  Max Size  Total Size  Total Time  Name
       6  1.3333MB  896.00KB  2.0000MB  8.000000MB  1.047456ms  Host To Device
     102  120.47KB  4.0000KB  0.9961MB  12.00000MB  1.184864ms  Device To Host
Total CPU Page faults: 51
```
