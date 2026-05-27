# Square Matrix Multiplication
This benchmark uses loops, comparing a naive implementations (`matmul.sis`) to a transposed variation (`matmul_tr.sis`) with better loop ordering. `matmul_tr.sh` is the preferred approach.

**Note:** This benchmark also times matrix generation and transposing (in the case of `matmul_tr.sis`).

## How to Run
First, compile the programme (either `matmul.sis` or `matmul_tr.sis`):
```sh
sisalc -o matmul_tr matmul_tr.sis
```
Then, run it by passing the matrix dimensions using `echo` (`-w$(nproc)` sets the number of threads, `-gss` is a scheduler flag, and `-z` silences the checksum output):
```sh
echo "1000" | time ./matmul_tr -w$(npoc) -gss -z
```

## Performance
Using `N=1000` on 12 threads (`-w12`), `matmul` achieves about **240-250ms** whereas `matmul_tr` achieves around **30-40ms**. Benchmarking varies depending on run.

A Julia implementation is provided in `matmul_tr.jl`. Using `@threads` to match the multi-threading behaviour when calling SISAL, it benchmarks in at around **130ms**.

Using Julia's built-in matrix multiplication (calling BLAS), it benchmarks at **8ms** (including matrix initialisation).

Switching to `LoopVectorization.jl` and calling `@tturbo` is similar to SISAL in the region of **35ms**. A strictly no-allocation version isn't tested, but will likely improve the runtime.

## Specs
**CPU:** 11th Gen Intel(R) Core(TM) i5-11400H (12) @ 4.50 GHz
**RAM:** 16GB
**Kernel:** Linux 7.0.10-arch1-1
**Julia:** 1.12.6
**Zig:** 0.17.0 
