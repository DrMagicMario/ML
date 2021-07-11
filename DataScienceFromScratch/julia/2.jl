#!/usr/local/bin/julia

using Pkg
Pkg.activate("jenv")
Pkg.instantiate()
using Printf
greet = "hello" * "world" # concatenation of two strings
print(greet, "\n")
@printf("pi = %0.20f", float(pi)) #C string formatting from Printf lib.


################################### Whitespace Formatting #####################################
function whitespace_demo()
  for i in [1,2,3,4,5]
    println(i)
    for j in [1,2,3,4,5]
      print(i)
      print(i+j)
    end
    println(i)
  end
end
#whitespace_demo()


########################################## Modules ###########################################
using Plots: Plots as plt 
import Plots as plt #same as above
@show plt

#specific values from a package
using StatsBase: countmap as cp
import StatsBase.countmap as cp #same as above
@show cp

