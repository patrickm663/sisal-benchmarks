FROM ubuntu:latest AS builder
ARG ZIG_VERSION=0.16.0

RUN apt-get update && apt-get install -y \
        wget \
        curl \
        build-essential \
        gcc \
        make \
        && rm -rf /var/lib/apt/lists/*

# Download and install Zig
RUN wget https://ziglang.org/download/${ZIG_VERSION}/zig-$(uname -m)-linux-${ZIG_VERSION}.tar.xz \
    && tar xf zig-$(uname -m)-linux-${ZIG_VERSION}.tar.xz \
    && mv zig-$(uname -m)-linux-${ZIG_VERSION} /usr/local/zig \
    && ln -s /usr/local/zig/zig /usr/local/bin/zig \
    && rm zig-$(uname -m)-linux-${ZIG_VERSION}.tar.xz

# Test Zig installation
RUN zig zen

# Download and compile Sisal
## Using Source Forge for now but may switch to GitHub mirror
RUN wget https://sourceforge.net/projects/sisal/files/latest/download/sisal-14.1.0.tgz \
    && tar xvfz sisal-14.1.0.tgz \
    && cd sisal-14.1.0/ \
    && ./configure CC="zig cc" \
    CFLAGS="-g -O3 -march=native -ffast-math -flto=thin -fno-math-errno -mllvm -enable-loopinterchange -mllvm -enable-loop-distribute -funroll-loops -mprefer-vector-width=512 -mllvm -force-vector-interleave=8 -mllvm -prefetch-distance=8 -mllvm --loop-prefetch-writes -fcommon -fPIC -std=gnu89 -Wno-int-conversion -Wno-implicit-function-declaration -Wno-implicit-int" \
    LIBS="-lm" \
    && make install \
    && cd .. \
    && rm -rf sisal-14.1.0/ sisal-14.1.0.tgz

FROM debian:trixie-slim
# Copy Sisal and Zig across
COPY --from=builder /usr/local/ /usr/local/

CMD ["sisalc", "--help"]
