# Sisal Benchmarks
This repo contains some common benchmarks. Documentation etc. will still follow. `matmul/` can be viewed with results and the code for the others can be inspected, but build and running instructions are TODO.

## A Note
We build Sisal from source a little differently, opting to use `zig cc` -- so CLang -- rather than `gcc`. The compilation flags are also quite aggressive, so it's not so much a reflection of what ordinary Sisal may achieve but how a little compiler magic can make it a high-performance language in the modern day.

Below are the build instructions on Linux (assuming Zig is installed):
```sh
wget https://sourceforge.net/projects/sisal/files/latest/download/sisal-14.1.0.tgz \
	&& tar xvfz sisal-14.1.0.tgz \
	&& cd sisal-14.1.0/
```
```sh
./configure CC="zig cc" \
	CFLAGS="-g -O3 -march=native -ffast-math -flto=thin -fno-math-errno -mllvm -enable-loopinterchange -mllvm -enable-loop-distribute -funroll-loops -mprefer-vector-width=512 -mllvm -force-vector-interleave=8 -mllvm -prefetch-distance=8 -mllvm --loop-prefetch-writes -fcommon -fPIC -std=gnu89 -Wno-int-conversion -Wno-implicit-function-declaration -Wno-implicit-int" \
	LIBS="-lm" \
```
```sh
sudo make install
```
```sg
cd ..
rm -rf sisal-14.1.0/ sisal-14.1.0.tgz
```

All Sisal programmes are now compiled using CLang, so other CLang flags can be used:
```
sisalc -o foo foo.sis
```
```
sisalc <CLang-flags> -o foo foo.sis
```
