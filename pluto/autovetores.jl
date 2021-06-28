### A Pluto.jl notebook ###
# v0.14.7

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 19c8a68a-d44e-11eb-26a1-c7f183a1f4b6
using Colors, LinearAlgebra, Plots, PlutoUI

# ╔═╡ 770b8128-ea37-4c3b-a761-9daf8fcb0358
begin
	function imagem!(plt; A=LinearAlgebra.I, ms=3, s=1, v=1, n=500)
		θrange = range(0, 2π, length=n+1)[1:n]
		colors = range(HSV(0, s, v), HSV(360, s, v), length=n)
		
		x = cos.(θrange)
		y = sin.(θrange)
		P = A * [x'; y']
		scatter!(plt, P[1,:], P[2,:], c=colors, m=(ms,stroke(0)))
		
		plt
	end
	
	function setas!(plt; A=LinearAlgebra.I, n = 8)
		θrange = range(0, 2π, length=n+1)[1:n]
		colors = range(HSV(0, 1, 1), HSV(360, 1, 1), length=n+1)[1:n]
		
		x = cos.(θrange)
		y = sin.(θrange)
		P = [x'; y']
		AP = A * P
		for i = 1:n
			plot!(plt, [0, P[1,i]], [0, P[2,i]], c=colors[i], l=:arrow)
			plot!(plt, [P[1,i], AP[1,i]], [P[2,i], AP[2,i]], c=colors[i], l=:arrow)
		end
		
		plt
	end
	
	function autovalores!(plt, A)
		Λ, V = eigen(A)
		if !(eltype(Λ) <: Real)
			return plt
		end
		Λ = round.(Λ, digits=3)
		V = round.(V, digits=3)
		
		α = 4.5
		if abs(Λ[2] - Λ[1]) > 1e-12 || rank(V) == 1
			θ = atan(V[2,1], V[1,1]) * 180 / π
			c = HSV(θ, 1, 1)
			plot!(plt, [0, α * V[1,1]], [0, α * V[2,1]], c=c, lw=3)
			plot!(plt, [0, α * V[1,1]], [0, α * V[2,1]], c=:white, lw=1)
			c = HSV(θ + 180, 1, 1)
			plot!(plt, [0, -α * V[1,1]], [0, -α * V[2,1]], c=c, lw=3)
			plot!(plt, [0, -α * V[1,1]], [0, -α * V[2,1]], c=:white, lw=1)
						
			θ = atan(V[2,2], V[1,2]) * 180 / π
			c = HSV(θ, 1, 1)
			plot!(plt, [0, α * V[1,2]], [0, α * V[2,2]], c=c, lw=3)
			plot!(plt, [0, α * V[1,2]], [0, α * V[2,2]], c=:white, lw=1)
			c = HSV(θ + 180, 1, 1)
			plot!(plt, [0, -α * V[1,2]], [0, -α * V[2,2]], c=c, lw=3)
			plot!(plt, [0, -α * V[1,2]], [0, -α * V[2,2]], c=:white, lw=1)
		else
			n = 2^5+1
			θrange = range(0, 2π, length=n)
			for i = 1:n-1
				c = HSV((θrange[i] + θrange[i+1]) * 90 / π, 0.2, 1)
				X = α * [0, cos(θrange[i]), cos(θrange[i+1]), 0]
				Y = α * [0, sin(θrange[i]), sin(θrange[i+1]), 0]
				plot!(X, Y, c=c, fill=true)
			end
		end
		plt
	end
	
	imagem(;kwargs...) = imagem!(plot(leg=false, axis_ratio=:equal); kwargs...)
end

# ╔═╡ 168158d0-468b-41d1-ac00-202cf6827478
md"""
a₁₁ = $(@bind a₁₁ Slider(-3.0:0.1:3.0, default=1, show_value=true))

a₁₂ = $(@bind a₁₂ Slider(-3.0:0.1:3.0, default=0, show_value=true))

a₂₁ = $(@bind a₂₁ Slider(-3.0:0.1:3.0, default=0, show_value=true))

a₂₂ = $(@bind a₂₂ Slider(-3.0:0.1:3.0, default=1, show_value=true))

θ = $(@bind θ Slider(range(0, 2π, length=61), show_value=true))
"""

# ╔═╡ 8f0afc90-fe8c-4038-bbb1-3c98b50614c0
begin
	# A = [0 0; 0 1]
	A = [a₁₁ a₁₂; a₂₁ a₂₂]
	# A = (A / 2)^4
	# A = 1.1 * [cos(θ) -sin(θ); sin(θ) cos(θ)]
	# A = A^6
	# A = 2 * [-1 0; 0 -1]
	# A = A^2 / maximum(eigen(A).values)
	# A = A^2 / maximum(eigen(A).values)
	# A = A^2 / maximum(eigen(A).values)
	# A = A^2 / maximum(eigen(A).values)
	
	plt = plot(leg=false, axis_ratio=:equal, size=(600,600), grid=false, axis=false)
	autovalores!(plt, A)
	imagem!(plt; A, ms=3, n=500)
	imagem!(plt, ms=2, v=0.7, n=500)
	# setas!(plt; n=16)
	setas!(plt; A, n=16)
	
	xticks!(Float64[])
	yticks!(Float64[])
	xlims!(-3, 3)
	ylims!(-3, 3)
	png("/home/abel/projetos/calculo-numerico/autovetores")
	plt
end

# ╔═╡ d48b2eb1-156b-4ed0-9ed6-42acf32bac4a
begin
	let
		c = round(cos(θ), digits=3)
		s = round(sin(θ), digits=3)
		Markdown.parse("""
	\$\$
		A = \\begin{bmatrix}
		$a₁₁ & $a₁₂ \\\\
		$a₂₁ & $a₂₂
			\\end{bmatrix} \\qquad
		M = \\begin{bmatrix}
		$(c) & $(-s) \\\\
		$(s) & $(c)
	\\end{bmatrix}\$\$
	""")
	end
end

# ╔═╡ 10679323-f5f5-4378-8281-8276dd9253a1
begin
	Λ, V = eigen(A)
	
	Λ = round.(Λ, digits=3)
	V = round.(V, digits=3)
	if !(eltype(Λ) <: Real)
		md"""
		## Autovalores complexos!
		"""
	elseif abs(Λ[2] - Λ[1]) >= 1e-8
		Markdown.parse("""
		## Autovalores distintos
		
		\$\$\\lambda_1 = $(Λ[1]), \\ \\lambda_2 = $(Λ[2])\$\$
		\$\$v_1 = \\begin{bmatrix}
			$(V[1,1]) \\\\ $(V[2,1])
			\\end{bmatrix}, \\
			v_2 = \\begin{bmatrix}
			$(V[1,2]) \\\\ $(V[2,2])
		\\end{bmatrix}
			\$\$
			
		\$\$A = \\begin{bmatrix}
			$a₁₁ & $a₁₂ \\\\
			$a₂₁ & $a₂₂
		\\end{bmatrix}
		=
		\\begin{bmatrix}
			$(V[1,1]) & $(V[1,2]) \\\\
			$(V[2,1]) & $(V[2,2])
		\\end{bmatrix}
		\\begin{bmatrix}
			$(Λ[1]) & 0 \\\\
			0 & $(Λ[2])
		\\end{bmatrix}
		\\begin{bmatrix}
			$(V[1,1]) & $(V[1,2]) \\\\
			$(V[2,1]) & $(V[2,2])
		\\end{bmatrix}^{-1}\$\$
		""")
	elseif rank(V) == 1
		Markdown.parse("""
		## Autovalores iguais e só um autovetor
		
		\$\$\\lambda = $(Λ[1]), \\qquad
			v = \\begin{bmatrix}
				$(V[1,1]) \\\\ $(V[2,1])
			\\end{bmatrix}\$\$
			
		\$\$A = \\begin{bmatrix}
			$a₁₁ & $a₁₂ \\\\
			$a₂₁ & $a₂₂
			\\end{bmatrix} \\quad \\text{não é diagonalizável}\$\$
		""")
	else
		Markdown.parse("""
		## Autovalores iguais e dois autovetores
			
		\$\$\\lambda_1 = $(Λ[1]), \\ \\lambda_2 = $(Λ[2])\$\$
		\$\$v_1 = \\begin{bmatrix}
			$(V[1,1]) \\\\ $(V[2,1])
			\\end{bmatrix}, \\
			v_2 = \\begin{bmatrix}
			$(V[1,2]) \\\\ $(V[2,2])
		\\end{bmatrix}
			\$\$
			
		\$\$A = \\begin{bmatrix}
			$a₁₁ & $a₁₂ \\\\
			$a₂₁ & $a₂₂
		\\end{bmatrix}
		=
		\\begin{bmatrix}
			$(V[1,1]) & $(V[1,2]) \\\\
			$(V[2,1]) & $(V[2,2])
		\\end{bmatrix}
		\\begin{bmatrix}
			$(Λ[1]) & 0 \\\\
			0 & $(Λ[2])
		\\end{bmatrix}
		\\begin{bmatrix}
			$(V[1,1]) & $(V[1,2]) \\\\
			$(V[2,1]) & $(V[2,2])
		\\end{bmatrix}^{-1}\$\$
		""")
	end
end

# ╔═╡ 5bac26cf-9730-426b-bfb3-00987b46d959
matV = eigen(A).vectors

# ╔═╡ 5efdc4ea-7dd5-4ac9-abd5-e66922a24a9d
matV' * matV

# ╔═╡ Cell order:
# ╠═19c8a68a-d44e-11eb-26a1-c7f183a1f4b6
# ╠═770b8128-ea37-4c3b-a761-9daf8fcb0358
# ╟─8f0afc90-fe8c-4038-bbb1-3c98b50614c0
# ╟─d48b2eb1-156b-4ed0-9ed6-42acf32bac4a
# ╟─168158d0-468b-41d1-ac00-202cf6827478
# ╟─10679323-f5f5-4378-8281-8276dd9253a1
# ╠═5bac26cf-9730-426b-bfb3-00987b46d959
# ╠═5efdc4ea-7dd5-4ac9-abd5-e66922a24a9d
