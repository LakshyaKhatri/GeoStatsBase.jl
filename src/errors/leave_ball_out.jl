# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    LeaveBallOut(ball; loss=Dict())

Leave-`ball`-out (a.k.a. spatial leave-one-out) validation.
Optionally, specify `loss` function from `LossFunctions.jl`
for some of the variables.

    LeaveBallOut(radius; loss=Dict())

By default, use Euclidean ball of given `radius` in space.

## References

* Le Rest et al. 2014. [Spatial leave-one-out cross-validation
  for variable selection in the presence of spatial autocorrelation]
  (https://onlinelibrary.wiley.com/doi/full/10.1111/geb.12161)
"""
struct LeaveBallOut{B<:BallNeighborhood} <: AbstractErrorEstimator
  ball::B
  loss::Dict{Symbol,SupervisedLoss}
end

LeaveBallOut(ball::BallNeighborhood; loss=Dict()) =
  LeaveBallOut{typeof(ball)}(ball, loss)

LeaveBallOut(radius::Number; loss=Dict()) =
  LeaveBallOut(BallNeighborhood(radius), loss=loss)

function error(solver::AbstractLearningSolver,
               problem::LearningProblem,
               eestimator::LeaveBallOut)
  sdata = sourcedata(problem)
  ovars = outputvars(task(problem))
  ball  = eestimator.ball
  loss  = eestimator.loss
  for var in ovars
    if var ∉ keys(loss)
      loss[var] = defaultloss(sdata[1,var])
    end
  end

  # efficient neighborhood search
  searcher = NeighborhoodSearcher(sdata, ball)

  # pre-allocate memory for coordinates
  coords = MVector{ncoords(sdata),coordtype(sdata)}(undef)

  solutions = map(1:nelms(sdata)) do i
    coordinates!(coords, sdata, i)

    # points inside and outside ball
    inside  = search(coords, searcher)
    outside = [j for j in 1:nelms(sdata) if j ∉ inside]

    # setup and solve learning sub-problem
    subproblem = LearningProblem(view(sdata, outside),
                                 view(sdata, [i]),
                                 task(problem))
    solve(subproblem, solver)
  end

  result = map(ovars) do var
    y = [sdata[i,var] for i in 1:nelms(sdata)]
    ŷ = [solutions[i][1,var] for i in 1:nelms(sdata)]
    var => value(loss[var], y, ŷ, AggMode.Mean())
  end

  Dict(result)
end
