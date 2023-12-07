using DrWatson
@quickactivate "DoseResponse"

using Revise
using DoseResponse

default(
    leg = false
)

p = (1., 3.)
x = range(log(0.1), log(2), length = 100) |> collect |> x-> exp.(x)


p1 = plot(x = "C_W", y = "y", xlabel = "C_W", ylabel = "y", ylim = (0,Inf), leg = true, title = "1/LL2")
[plot!(p1, x, 1 ./ [LL2(xi, (1., b)) for xi in x], label = "beta = $b") for b in [2., 3., 4., 5.]]

p2 = plot(x = "C_W", y = "y", xlabel = "C_W", ylabel = "y", ylim = (0,Inf), title = "1-ln(LL2)")
[plot!(p2, x, [LL2M(xi, (1., b)) for xi in x]) for b in [2., 3., 4., 5.]]

plot(p1, p2) 








