# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    ErrorEstimationMethod

A method for estimating error of geostatistical solvers.
"""
abstract type ErrorEstimationMethod end

"""
    error(solver, problem, method)

Estimate error of `solver` in a given `problem` with
error estimation `method`.
"""
Base.error(solver, problem, ::ErrorEstimationMethod)

# ----------------
# IMPLEMENTATIONS
# ----------------

include("errors/loo.jl")
include("errors/lbo.jl")
include("errors/kfv.jl")
include("errors/bcv.jl")
include("errors/wcv.jl")
include("errors/drv.jl")
