# github.com/abelsiqueira/calculo-numerico-em-julia

#%%
function derivada(f, x, h = 1e-8)
  (f(x + h) - f(x)) / h
end

#%%
derivada(x -> x^2 + 1, 2.0)

#%%
n = 1

#%%
n = n + 1
println("n = $n")

#%%
include("bhaskara.jl")

bhaskara(1, 5, 6) |> println

#%%
using ForwardDiff

ForwardDiff.derivative(x -> x^2 + 1, 2.0) |> println