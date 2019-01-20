using Plots
using QuadGK
using Calculus

function main(args)
    k = parse(Float64, args[1])
    n = parse(Int64, args[2])

    u0 = 5
    r = 1   # range length
    up1 = 3
    h = r / (n - 1)
    f(x) = 5x - 10

    function tent(x::Float64, i::Integer)
        if ((i - 1) * h <= x <= i * h)
            (x - (i - 1) * h) / h
        elseif (i * h < x < (i + 1) * h)
            ((i + 1) * h - x) / h
        else
            0
        end
    end

    base = [x -> tent(x, i) for i in 0:(n-1)]

    # In case, equation are to be derived from integrals
    # B(w, v) = quadgk(x -> k * derivative(w, x) * derivative(v, x) + derivative(w, x) * v(x), 0, 1)[1] + k * derivative(w, 0) * v(0.0) 
    # L(v) = quadgk(x -> f(x) * v(x) + 5 * v(x), 0, 1)[1] + 8 * k * v(1.0)

    BMatrix = zeros(Float64, n, n)
    LMatrix = zeros(Float64, n)

    for i in 2:n
        BMatrix[i, i] = 2 * k * (n - 1)
        BMatrix[i - 1, i] = - k * (n - 1) + 1/2
        BMatrix[i, i - 1] = - k * (n - 1) - 1/2 
        LMatrix[i] = 5 * h * ((i - 1) * h - 1) + 8 * k * base[i](1.0)
    end
    BMatrix[1, 1] = k * (n - 1) - 1/2   # -1/2 for the slope of the tent
    BMatrix[n, n] = k * (n - 1) + 1/2   # +1/2 for the slope of the tent
    BMatrix[1, 2] = - k * (n-1) / 2 + 1/2

    WMatrix = BMatrix \ LMatrix

    w = x -> sum(WMatrix[i] * base[i](x) for i in 1:n)
    u = x -> w(x) + (1.0 - x)*5.0

    xs = range(0, length=n, stop=1)
    ys = [u(x) for x in xs]
    plt = plot(xs, ys, title="result")
    display(plt)
    
    readline()
end

main(ARGS)