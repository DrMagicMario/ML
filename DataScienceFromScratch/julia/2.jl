#!/usr/local/bin/julia

using Pkg
Pkg.activate("jenv")
Pkg.instantiate()
using Printf
greet = "hello" * "world" # concatenation of two strings
print(greet, "\n")
@printf("pi = %0.20f\n", float(pi)) #C string formatting from Printf lib.


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
  println(sqrt(-1))
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
#index_demo()

#list membership
println("$(1 in [1,2,3]), $(0 in [1,2,3])")

function concat_demo()
  x = [1,2,3]
  cat_y = cat(x,[4,5,6]; dims=1)
  vcat_y = vcat(x,[4,5,6])
  println("x: $x, cat_y: $cat_y, vcat_y: $vcat_y")
  append!(x, [4,5,6,0]) 
  println("x: $x")
end
#concat_demo()
  
#unpacking
function unpack_demo()
  x,y = [1,2]
  println("x: $x, y: $y")
end
#unpack_demo()


########################################### Tuples #############################################
#immutable lists
function tuple_demo()
  mylist = [1,2]
  mytuple = (1,2)
  othertuple = 3,4
  mylist[1] = 3
  try
    mytuple[1] = 3
    othertuple[1] = 3
  catch e
    println("cannot modify tuples")
  end
  println(mylist, mytuple, othertuple)
end
#tuple_demo()

#multiple assignment
x,y = 1,2
x,y = y,x
println("x: $x, y: $y") # 2,1


####################################### Dictionaries #########################################
empty_dict = Dict{Int,Any}()
grades_v1 = Dict([("Joel",80), ("Tim",95)])
grades_v2 = Dict("Joel" => 80, "Tim"=>95)
println("init a Dict: $empty_dict, $grades_v1, $grades_v2")

function index_demo()
  joels_grade = grades_v1["Joel"]
  try
    kates_grade = grades_v1["Kate"]
  catch e
    println("no key named Kate")
  end
  grades_v1["Tim"] = 99
  grades_v1["Kate"] = 100
  println("joel: $joels_grade, every1: $grades_v1")
end
#index_demo()

println("$(haskey(grades_v1,"Joel")), $(haskey(grades_v1,"Kate"))")
println("$(get(grades_v1,"Joel",0)), $(get(grades_v1,"Kate",0))")

c = cp([0,1,2,0])
println(c)

function set_demo()
  s = Set()
  push!(s,1,2,2)
  x = length(s)
  y = 2 in s
  z = 3 in s
  println(s,x,y,z)
  item_list = [1,2,3,1,2,3]
  item_set = Set(item_list)
  println("item, length: $item_list, $(length(item_list))")
  println("item, length: $item_set, $(length(item_set))") #unique items only
end
#set_demo()


####################################### Control Flow #########################################

function ifthanelse_demo()
  if 1>2
    msg = "if"
  elseif 1>3
    msg = "elseif"
  else
    msg = "else"
  end
  println("$msg")
end
#ifthanelse_demo()

#ternary
println(x%2==0 ? "even" : "odd")

#while
let x = 0
  while x<10
    println("$x is less than 10")
    x+=1
  end
end

#for
for x in collect(0:9)
  if x==3
    continue #pass
  end
  if x==5
    break #break out of loop
  end
  println(x)
end


########################################### Truth ############################################
mybool = 1<2
otherbool = true==false
println("$mybool, $otherbool") #true, false

none = nothing
println("none = nothing?: $(none == nothing), none = NaN?: $(none==NaN)")


########################################### Sorting ###########################################
function sort_demo()
  x = [-4,1,-2,3]
  y = sort(x)
  println(x,y)
  sort!(x, by=abs)
  sort!(y, rev=true, alg=InsertionSort)
  println(x,y)
end
#sort_demo()


#################################### List comprehensions ######################################
function listcomp_demo()
  #List
  even = [x for x in 0:4 if x%2==0]
  squares = [x*x for x in 0:4]
  evensquares = [x*x for x in 0:4 if x%2==0]
  #Dicts
  square_dict = Dict(x => x*x for x in 0:4)
  square_set = Set(x*x for x in [1,-1])
  #multiple fors
  pairs = [(x,y) for x in 0:9 for y in 0:9]
  inc_pairs = [(x,y) for x in 0:9 for y in x+1:9]
  println("even: $even\nsquares: $squares\nevensquares: $evensquares\n",
          "square_dict: $square_dict\nsquare_set: $square_set\npairs: $pairs\n",
          "inc_pairs: $inc_pairs")
end
#listcomp_demo()


#################################### Randomness ######################################
using Random, StatsBase
function random_demo()
  uniform = [rand(Int) for i in 0:4]
  shuffled = shuffle(uniform)
  bf = sample(["alice","bob","charlie"])
  winning_lotto = sample(0:59, 6)
  forrand = [sample(0:9) for i in 0:4]
  Random.seed!(10) #sets seed
  println("uniform: $uniform\nshuffled: $shuffled\nbf: $bf\nwinning lotto: $winning_lotto\n",
          "forrand: $forrand\nrandom ints: $(rand(10))")
end
#random_demo()


########################################### Regex ##########################################
function regex_demo()
  rgx1, rgx2 = r"a", r"c"
  println("rgx1 matches cat: $(match(rgx1,"cat"))\nrgx1 occursin cat: $(occursin(rgx1,"cat"))\n","$(3==length(split("carbs", r"[ab]"))), $("R-D-" == replace("R2D2", r"[0-9]"=> "-"))")
end
#regex_demo()
  

#################################### Funcitonal Tools ########################################
#manual partial
exp(base, power) = base^power
two_to_the(power) = exp(2, power)
square_of(expo) = exp(expo, 2)
println("$(two_to_the(3)), $(square_of(3))")

#reduce, map, filter
xs = [1, 2, 3, 4]
multiply(x,y)=x*y
is_even(x)=x%2==0

function rmf_test()
  twice_xs = [double(x) for x in xs] # [2, 4, 6, 8]
  map_xs = map(double, xs) # same as above
  products = map(multiply, [1,2], [4,5]) #map can do multiple args
  x_evens = [x for x in xs if is_even(x)] # [2, 4]
  filt_evens = filter(is_even, xs) # same as above
  x_product = reduce(multiply, xs) # = 1 * 2 * 3 * 4 = 24
  println("twice_xs: $twice_xs\nmap_xs: $map_xs\nproducts: $products\n",
          "x_evens: $x_evens\nfilt_evens: $filt_evens\nx_product: $x_product\n")
end
#rmf_test()


#################################### Zip and Packing ########################################
# Zip: transforms lists into a single list of tuples of corresponding elements
function zip_demo() #zip stops as soon as the first list ends.
  list1 = ['a', 'b', 'c']
  list2 = [1, 2, 3]
  list3 = zip(list1, list2)
  pairs = [('a', 1), ('b', 2), ('c', 3)]
  letters, numbers = zip(pairs...) #unzip
  unzip_raw = zip(('a', 1), ('b', 2), ('c', 3))
  println("list3: $list3\nletters: $letters\nnumbers: $numbers\nunzip_raw: $unzip_raw")
end
#zip_demo()

#use args unpackin everywhere!
myadd(x,y) = x+y
println("$(myadd(1,2)), $(myadd([1,2]...))") # 3,3
try
  myadd([1,2])
catch e
  println("invalid arg type")
end


#################################### args and kwargs ########################################
function magic(args... ; kwargs...)
  println("unnamed args: $args\nkeyword args: $kwargs")
end
magic(1,2,key1="hello",key2="world")

other_magic(x,y,z) = x+y+z
xylist = [1,2]
zdict = Dict("z" => 3)
println(other_magic(xylist..., get(zdict,"z",3)))
