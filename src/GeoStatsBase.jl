# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

module GeoStatsBase

using Meshes
using Tables
using GeoTables
using TableTransforms
using Rotations: RotZYX
using Distributions: median
using Combinatorics: multiexponents
using Distances: Euclidean, pairwise
using Distributed: CachingPool, pmap, myid
using StatsBase: Histogram, AbstractWeights
using StatsBase: midpoints, sample, mode
using Transducers: Map, foldxt
using LossFunctions: L2DistLoss
using DensityRatioEstimation
using ScientificTypes
using ProgressMeter
using LinearAlgebra
using Random

using TypedTables # for a default table type
using Optim # for LSIF estimation

import Meshes: partitioninds
import Meshes: sampleinds
import Meshes: sortinds
import GeoTables: domain
import MLJModelInterface as MI
import LossFunctions.Traits: SupervisedLoss
import TableTransforms: StatelessTableTransform
import TableTransforms: StatelessFeatureTransform
import TableTransforms: ColSpec, Col, AllSpec, NoneSpec
import TableTransforms: colspec, choose
import TableTransforms: apply, revert, reapply
import TableTransforms: applyfeat, revertfeat
import TableTransforms: applymeta, revertmeta
import TableTransforms: divide, attach
import TableTransforms: isrevertible
import StatsBase: fit, varcorrection, describe
import Statistics: mean, var, quantile
import Base: ==

# geotable specializations
include("geotables.jl")

include("georef.jl")
include("ensembles.jl")
include("macros.jl")
include("trends.jl")
include("estimators.jl")
include("weighting.jl")
include("geoops.jl")
include("learning.jl")
include("problems.jl")
include("solvers.jl")
include("initbuff.jl")
include("folding.jl")
include("errors.jl")
include("statistics.jl")
include("histograms.jl")
include("rotations.jl")
include("transforms.jl")

export
  # data
  georef,

  # ensembles
  Ensemble,

  # learning tasks
  LearningTask,
  SupervisedLearningTask,
  UnsupervisedLearningTask,
  RegressionTask,
  ClassificationTask,
  issupervised,
  inputvars,
  outputvars,
  features,
  label,

  # learning models
  issupervised,
  isprobabilistic,
  iscompatible,

  # learning losses
  defaultloss,

  # problems
  Problem,
  EstimationProblem,
  SimulationProblem,
  LearningProblem,
  data,
  domain,
  sourcedata,
  targetdata,
  task,
  variables,
  nreals,

  # solvers
  Solver,
  EstimationSolver,
  SimulationSolver,
  LearningSolver,
  targets,
  covariables,
  preprocess,
  solve,
  solvesingle,

  # initialization
  InitMethod,
  NearestInit,
  ExplicitInit,
  initbuff,

  # folding
  FoldingMethod,
  UniformFolding,
  OneFolding,
  BlockFolding,
  BallFolding,
  folds,

  # errors
  ErrorEstimationMethod,
  LeaveOneOut,
  LeaveBallOut,
  KFoldValidation,
  BlockValidation,
  WeightedValidation,
  DensityRatioValidation,

  # helper macros
  @estimsolver,
  @simsolver,

  # estimators
  Estimator,
  ProbabilisticEstimator,
  fit,
  predict,
  predictprob,
  status,

  # weighting
  GeoWeights,
  WeightingMethod,
  UniformWeighting,
  BlockWeighting,
  DensityRatioWeighting,
  weight,

  # trends
  polymat,
  trend,

  # histograms
  EmpiricalHistogram,

  # statistics
  mean,
  var,
  quantile,

  # utilities
  describe,
  integrate,
  geosplit,
  @groupby,
  @transform,
  @combine,

  # rotations
  DatamineAngles,
  GslibAngles,
  VulcanAngles,

  # transforms
  Detrend,
  Potrace,
  UniqueCoords

end
