#!/usr/local/bin/julia

using Pkg
Pkg.activate("jenv")
Pkg.instantiate()


#=

=#
function sum_of_squares(v)
  """computes the sum of squared elements v"""
  return sum(vi^2 for vi in v)
end



print("im alive")
