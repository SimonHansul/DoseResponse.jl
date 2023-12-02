using DrWatson
@quickactivate "DoseResponse"

using Revise
using DoseResponse

p = (1., 3.)
x = range(log(0.1), log(10), length = 100) |> collect |> x-> exp.(x)


plot(x, LL2M())
LL2M(1., p) - 1