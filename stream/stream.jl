using BenchmarkTools

function copy_kernel(b::Vector{Float64})
    return [b[i] for i in eachindex(b)]
end

function scale_kernel(q::Float64, b::Vector{Float64})
    return [q * b[i] for i in eachindex(b)]
end

function add_kernel(b::Vector{Float64}, c::Vector{Float64})
    return [b[i] + c[i] for i in eachindex(b)]
end

function triad_kernel(q::Float64, b::Vector{Float64}, c::Vector{Float64})
    return [b[i] + q * c[i] for i in eachindex(b)]
end

function stream_bench(n::Int, kernel::Int)
    a = [Float64(i - 1) for i in 1:n]
    b = [Float64(i - 2) for i in 1:n]
    q = 0.1234
    c = if kernel == 0; copy_kernel(a)
        elseif kernel == 1; scale_kernel(q, a)
        elseif kernel == 2; add_kernel(a, b)
        elseif kernel == 3; triad_kernel(a, b)
        else; a
        end
    return c[end]
end

n = 50_000_000

println("Triad:")
@btime stream_bench($n, 4)
