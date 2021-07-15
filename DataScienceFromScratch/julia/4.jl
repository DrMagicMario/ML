#!/usr/local/bin/julia

######################################### Vectors #############################################
hght_w8_age = [70, #inches
              170, #pounds
              40] #years
grades = [95, #exam1
          80, #exam2
          75, #exam3
          62] #exam4

vector_add(v,w) = [v+w for (v,w) in zip(v,w)]
vector_subtract(v,w) = [v-w for (v,w) in zip(v,w)]
vectorsum(vectors) = reduce(vector_add,vectors)

#component wise mean
vector_mean(vectors) = mul!(Y=similar(vectors), 1/(length(vectors)), vectorsum(vectors))

#v1*v1 + v2*v2 +...+ vn*wn
sum_of_squares(v) = dot(v,v) 

magnitude(v) = sqrt(sum_of_squares(v))

#distance between two vectors
squared_distance(v,w) = sum_of_squares(vector_subtract(v,w))
distance(v,w) = magnitude(vector_subtract(v,w))


######################################### Matrices ############################################
#2D collection of numbers: lists of lists
B = [1 2
     3 4 
     5 6]

A = [1 2 3
     4 5 6]

Ap = reshape(1:6, 3,2)' #julia is column major by default. ' symbol adjoins a matrix
Bp = reshape(1:6, 2,3)' #trick to get matrices axis flipped

println("A: $A\nAp: $Ap\nB: $B\nBp: $Bp")
println("A == Ap?: $(A==Ap)\nB == Bp?: $(B==Bp)")

println("A (ndims, size, length, row 1, column 1): $(ndims(Ap)), $(size(Ap)), $(length(Ap)),",
        " $(getindex(Ap, 1:2:6)) or $(first(eachrow(Ap))),",
        " $(getindex(Ap, 1:2)) or $(first(eachcol(Ap)))",
        "B (ndims, size, length): $(ndims(Bp)), $(size(Bp)), $(length(Bp))\n",
        "B (row 1, column 1): $(getindex(Bp, 1:3:6)), $(getindex(Bp, 1:3))\n")

using LinearAlgebra
@show Matrix(1*I,5,5) # identity matrix
"""
  IRL: use LinearAlgebra library, this was just for intro
"""




