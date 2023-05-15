# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    EstimationProblem(sdata, sdomain, vars)

A spatial estimation problem on a given spatial domain `sdomain`
in which the variables to be estimated are listed in `vars`.
The data of the problem is stored in spatial data `sdata`.

## Examples

Create an estimation problem for precipitation measurements:

```julia
julia> EstimationProblem(sdata, sdomain, :precipitation)
```

Create an estimation problem for precipitation and CO₂:

```julia
julia> EstimationProblem(sdata, sdomain, (:precipitation,:CO₂))
```
"""
struct EstimationProblem{S,D,N} <: Problem
  sdata::S
  sdomain::D
  vars::NTuple{N,Variable}

  function EstimationProblem{S,D,N}(sdata, sdomain, vars) where {S,D,N}
    pnames = name.(vars)
    dnames = name.(variables(sdata))
    valid = !isempty(pnames) && pnames ⊆ dnames

    T1 = coordtype(domain(sdata))
    T2 = coordtype(sdomain)

    @assert valid "target variables must be present in geospatial data"
    @assert T1 == T2 "data and domain must have the same coordinate type"

    new(sdata, sdomain, vars)
  end
end

function EstimationProblem(sdata::S, sdomain::D, varnames::NTuple{N,Symbol}) where {S,D,N}
  # find variables in spatial data
  vars = filter(v -> name(v) ∈ varnames, variables(sdata))
  EstimationProblem{S,D,N}(sdata, sdomain, vars)
end

EstimationProblem(sdata, sdomain, varname::Symbol) = EstimationProblem(sdata, sdomain, (varname,))

"""
    data(problem)

Return the spatial data of the estimation `problem`.
"""
data(problem::EstimationProblem) = problem.sdata

"""
    domain(problem)

Return the spatial domain of the estimation `problem`.
"""
Meshes.domain(problem::EstimationProblem) = problem.sdomain

"""
    variables(problem)

Return the variable names of the estimation `problem` and their types.
"""
variables(problem::EstimationProblem) = problem.vars

# ------------
# IO methods
# ------------
function Base.show(io::IO, problem::EstimationProblem)
  Dim = embeddim(problem.sdomain)
  print(io, "$(Dim)D EstimationProblem")
end

function Base.show(io::IO, ::MIME"text/plain", problem::EstimationProblem)
  vars = ["$(name(v)) ($(mactype(v)))" for v in problem.vars]
  println(io, problem)
  println(io, "  domain:    ", problem.sdomain)
  println(io, "  samples:   ", domain(problem.sdata))
  print(io, "  targets:   ", join(vars, ", ", " and "))
end
