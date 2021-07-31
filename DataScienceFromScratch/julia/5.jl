#!/usr/local/bin/julia
using Pkg
Pkg.activate("jenv")
Pkg.instantiate()

using Plots, Random, StatsBase, DataStructures, LinearAlgebra
gr()

#=

  Chapter 5: Statistics

=#

#dataset
Random.seed!(1234) #reproducability
numFriends = [rand(1:100) for x in 1:100]

#Visualization: Histogram
friendCount = counter(numFriends)
xs = 1:100
ys = [friendCount[x] for x in xs]
#@time bar(xs,ys,xlabel="# of friends",ylabel="# of people",title="Histogram of Friend Counts",show=true,ylims=(0,25))


#Basic Stats
function basic_stats()
  @time numPoints = length(numFriends)
  @time maxVal = max(numFriends...)
  @time minVal = min(numFriends...)
  println("number of points: $numPoints\nmax value: $maxVal\nmin value: $minVal")
end
#basic_stats()


#################################### Central tendencies #####################################
#average
function mean(x)
  return sum(x)/length(x)
end
#println(mean(numFriends))

#middle-most value
function median(x)
  n = length(x)
  sort!(x)
  midpoint = Int(floor(n/2))
  if n%2==1 #odd number values
    return x[midpoint]
  else #even number of values
    lo = midpoint-1
    hi = midpoint
    return (x[lo]+x[hi])/2
  end
end
#println(median(numFriends))

#represents the value less than which a certain percentile of the data lies.
function quantile(x,p)
  idx = Int(p*length(x))
  return sort(x)[idx]
end
#println("quantile @ 10,25,75,90 percent: $(quantile(numFriends,0.1)), $(quantile(numFriends,0.25)), $(quantile(numFriends,0.75)), $(quantile(numFriends,0.9))")

function mode(x)
  counts = countmap(x)
  maxCount = max(collect(values(counts))...)
  println("counts: $counts\nmaxCount: $maxCount")
  return [xi for (xi,count) in counts if count==maxCount]
end
#println(mode(numFriends))


######################################## Dispersion #########################################

#=  measures how spread out data is:
      *values near zero signify not spread out at all
      *large value signify very spread out.
=#

function data_range(x)
  return max(x...)-min(x...)
end
#println("data range: $(data_range(numFriends))")

#Variance

function de_mean(x)
  xbar = mean(x)
  return [xi-xbar for xi in x]
end

sum_of_squares(x) = dot(x,x)

#measures how a single variable deviates from its mean
function variance(x)
  n = length(x)
  deviations = de_mean(x)
  return sum_of_squares(deviations)/(n-1)
end
#println("Variance: $(variance(numFriends))")

function stddev(x)
  return sqrt(variance(x))
end
#println("standard deviation: $(stddev(numFriends)))")


function interquartile_range(x)
  return quantile(x,0.75) - quantile(x,0.25)
end
#println("interquartile range: $(interquartile_range(numFriends))")


######################################## Correlation #########################################

#measures how two variables vary in tandem from their means
function covariance(x,y)
   n = length(x)
   return dot(de_mean(x),de_mean(y))/(n-1)
end

#dailyminutes dataset
dailyMinutes = [rand(1:1000) for x in 1:100]
#println("Covariance: $(covariance(numFriends,dailyMinutes))")


function correlation(x,y)
  stddevx = stddev(x)
  stddevy = stddev(y)
  if stddevx>0 && stddevy>0
    return covariance(x,y)/stddevx/stddevy
  else
    return 0
  end                  
end
println("Correlation: $(correlation(numFriends,dailyMinutes))")


readline() #wait for user input to exit

