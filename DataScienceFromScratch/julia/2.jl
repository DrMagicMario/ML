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

using DataStructures
lookup = DefaultDict(Int)
mycounter = counter(Int) #DataStructures doesnt provide default constructor :(
myregex = r"[0-9]+"
println(lookup,mycounter,myregex)


########################################## Functions ###########################################
function double(x)
  """docstring"""
  return x*2
end

function applyfunc(f)
  """calls function f with arg=1"""
  return f(1)
end

mydouble = double
x = applyfunc(mydouble) #passes 1 to double()
println(x) #2

#anon. funcs:
y = applyfunc(x -> x+4)
println(y) #5

#=
Optional arguments: Optional args passed from left to right of func def. 
=#
function myprint(msg1 = "default", msg2 = "message")
  return msg1 * msg2
end
print(myprint()*"\n")
print(myprint("hello")*"\n") #msg1 = hello

#=
keyword arguments:  Defined using a semicolon in the signature ';' 
                    Optional args passed first, followed by Keyword args
                    Keyword args Must be referred to by keyword
=#
function mysubtract(x=0, y=0; a=0, b=0)
  return x-y,a-b 
end
println(mysubtract(10,5))   #(5,0)  -> x,y passed
println(mysubtract(0,5))    #(-5,0) -> x,y passed
println(mysubtract(5,b=5))  #(5,-5) -> x,b passed


########################################## Strings ###########################################
#julia doesnt have single quotes
myquote = "data science"

tab = "\t"
nottab = "\\t"
println("$(length(tab)) $(length(nottab))")

multiline = """this is the first line.
this is the second line
this is the last line
"""
println(multiline)


######################################## Exceptions ###########################################
try
  print(sqrt(-1))
catch e
  println("can't sqrt a negative number")
end


########################################### Lists #############################################

intlist = [1,2,3]
heterolist = ["string", 0.1, true]
listoflists= [intlist, heterolist, []]
println("length intlist: $(length(intlist)), sum intlist: $(sum(intlist))")
println(heterolist, listoflists) #Any["string", 0.1, true], Vector{Any}[[1, 2, 3], ["string", 0.1, true], []]

#indexing
function index_demo()
  x = collect(0:9)
  zero = x[1]
  one = x[2]
  nine = x[end]
  eight = x[end-1]
  x[1] = -1
  println("zero=$zero, one = $one, nine=$nine, eight=$eight, x=$x")
end

index_demo()
