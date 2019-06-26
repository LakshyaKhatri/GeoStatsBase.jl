# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    Curve(x, y, z, ...)

A curve along coordinates `x`, `y`, `z`, ...
"""
struct Curve{T,N} <: AbstractDomain{T,N}
  coords::Matrix{T}
end

function Curve(coordarrays::Vararg{<:AbstractVector{T},N}) where {N,T}
  npts = length.(coordarrays)
  @assert length(unique(npts)) == 1 "coordinates arrays must have the same dimensions"

  coords = Matrix{T}(undef, N, npts[1])
  for (i, array) in enumerate(coordarrays)
    coords[i,:] = array
  end

  Curve{T,N}(coords)
end

Curve(coords::AbstractMatrix{T}) where {T} = Curve{T,size(coords,1)}(coords)

npoints(curve::Curve) = size(curve.coords, 2)

function coordinates!(buff::AbstractVector{T}, curve::Curve{T,N},
                      location::Int) where {N,T}
  for i in 1:N
    @inbounds buff[i] = curve.coords[i,location]
  end
end

# ------------
# IO methods
# ------------
function Base.show(io::IO, curve::Curve{T,N}) where {N,T}
  npts = size(curve.coords, 2)
  print(io, "$npts Curve{$T,$N}")
end

function Base.show(io::IO, ::MIME"text/plain", curve::Curve{T,N}) where {N,T}
  println(io, curve)
  Base.print_array(io, curve.coords)
end