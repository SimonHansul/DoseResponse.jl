using DrWatson
@quickactivate "DoseResponse"

using Revise
using DoseResponse

default(
    leg = false
)

p = (1., 3.)
x = range(log(0.1), log(2), length = 100) |> collect |> x-> exp.(x)


plot(x, 1 ./ [LL2(xi, p) for xi in x], x = "C_W", y = "y")
plot(x, [LL2M(xi, p) for xi in x], x = "C_W", y = "y", xscale = :log10)
vline!([1])








