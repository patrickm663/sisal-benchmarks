using Base.Threads
using LoopVectorization

function generate_matrix_flat(N::Int, is_B::Bool)
    M = Matrix{Float64}(undef, N, N)
    @threads for j in 1:N
        for i in 1:N
            if is_B
                M[i, j] = Float64(i) - Float64(j) + 0.5
            else
                M[i, j] = Float64(i) + Float64(j) * 0.1
            end
        end
    end
    return M
end

function manual_transpose_flat(M::Matrix{Float64}, N::Int)
    M_T = Matrix{Float64}(undef, N, N)
    @tturbo for j in 1:N # replaces @threads
        for i in 1:N
            M_T[j, i] = M[i, j]
        end
    end
    return M_T
end

function main_benchmark_flat(N::Int)
    A = generate_matrix_flat(N, false)
    B = generate_matrix_flat(N, true)

    B_T = manual_transpose_flat(B, N)

    C = Matrix{Float64}(undef, N, N)
    @tturbo for j in 1:N
        for i in 1:N
            s = 0.0
            for k in 1:N
                s += A[i, k] * B_T[j, k]
            end
            C[i, j] = s
        end
    end

    return C[N, N]
end

function main_benchmark_linalg(N::Int)
    A = generate_matrix_flat(N, false)
    B = generate_matrix_flat(N, true)

    C = A * B

    return C[N, N]
end
