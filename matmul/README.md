# Square Matrix Multiplication
This benchmark uses loops, comparing a naive implementations (`matmul.sis`) to a transposed variation (`matmul_tr.sis`) with better loop ordering. `matmul_tr.sh` is the preferred approach.

**Note:** All benchmarks time matrix generation and transposing (in the case of `matmul_tr.sis`).

## TLDR
### Performance Benchmarks (`N=1000`)

Benchmarked on 12 threads (`-w12`). Note: Benchmarking varies depending on the run.

SISAL benchmarking uses ` hyperfine --warmup 20 --runs 100 'echo "1000" | ./matmul_tr -w$(nproc) -gss -z'`

Julia uses `@benchmark main_benchmark_X(1000) samples=100 evals=1 setup=(GC.gc())` to remove the impact of the garbage collector

| Implementation | Environment / Backend | Mean Execution Time | Notes |
| :--- | :--- | :--- | :--- |
| `matmul.sis` | SISAL | **274.5ms** | Naive implementation. |
| `matmul_tr.sis` | SISAL | **43.2ms** | Transposed matrix implementation. |
| `matmul_tr.jl` (`@threads`) | Julia (Native) | **172.1ms** | Transposed implementation and matches the multi-threading behavior of calling SISAL. |
| `LoopVectorization.jl` (`@tturbo`) | Julia (Native LLVM) | **13.1ms** | Performance is similar to BLAS. |
| Built-in Matrix Multiplication | Julia (OpenBLAS) | **12.8ms** | Default BLAS. Includes matrix initialisation time. |

## How to Run
First, compile the programme (either `matmul.sis` or `matmul_tr.sis`):
```sh
sisalc -o matmul_tr matmul_tr.sis
```
Then, run it by passing the matrix dimensions using `echo` (`-w$(nproc)` sets the number of threads, `-gss` is a scheduler flag, and `-z` silences the checksum output):
```sh
echo "1000" | time ./matmul_tr -w$(npoc) -gss -z
```

## Specs
- **CPU:** 11th Gen Intel(R) Core(TM) i5-11400H (12) @ 4.50 GHz
- **RAM:** 16GB
- **Kernel:** Linux 7.0.10-arch1-1
- **Julia:** 1.12.6
- **Zig:** 0.17.0 
