#!/usr/local/bin/julia

using Pkg
Pkg.activate("jenv")
Pkg.instantiate()

using StatsBase, Plots, Random, SpecialFunctions
gr()
#= ########################################################################################
    Exploring One-Dimensional Data: 
        *Summary Statistics
            **how many data points, smallest/largest, mean, standard deviation

    Ex. daily average number of minutes each user spends on your site
=# #######################################################################################

#create a histogram; group your data into discrete buckets and count points in each bucket
function inverse_normal_cdf(p;mu=0,sigma=1,tolerance=0.00001)
    """find approximate inverse using binary search"""
    
    #if not standard, compute standard and rescale
    if mu!=0 || sigma != 1
        return mu+sigma*inverse_normal_cdf(p;tolerance=tolerance)
    end

    low_z, low_p = -10.0, 0 # normal_cdf(-10) ~ 0
    hi_z, hi_p = 10.0, 1  # normal_cdf(10) ~ 1
    println("low_z: $low_z\tlow_p: $low_p\thi_z: $hi_z\thi_p: $hi_p")
    let
      mid_z, mid_p = 0, 0
      while hi_z - low_z > tolerance
        println("\n\t$(hi_z-low_z) > $(Float64(tolerance)) = $(hi_z-low_z > tolerance)")
        mid_z = (low_z + hi_z) / 2 # consider the midpoint
        mid_p = normal_cdf(mid_z) # and the cdf's value there
        println("\tmid_z: $mid_z\n\tmid_p: $mid_p\n\tp: $p")
        if mid_p < p
          # midpoint is still too low, search above it
          println("\t\t$mid_p < $p = $(mid_p<p)")
          low_z, low_p = mid_z, mid_p 
          println("\t\tlow_z = mid_z = $low_z\n\t\tlow_p = mid_p = $low_p")
        elseif mid_p > p
          # midpoint is still too high, search below it
          println("\t\t$mid_p > $pi = $(mid_p>p)")
          hi_z, hi_p = mid_z, mid_p 
          println("\t\thi_z = mid_z = $hi_z\n\t\thi_p = mid_p = $hi_p\n")
        end
      end
      println("\tmid_z: $mid_z")
      return mid_z
    end
end

function normal_cdf(x; mu=0, sigma=1)
  return (1+erf((x-mu)/sqrt(2)/sigma))/2
end

function bucketsize(point, bucket_size)
    """floor the point to the next lower multiple of bucket_size"""
    floor_point = bucket_size*floor(point/bucket_size)
    return floor_point
end

function make_hist(points, bucket_size)
    """buckets the points and coints # of point in aech bucket"""
    buckets = countmap(bucketsize(point,bucket_size) for point in points)
    return buckets
end

function plot_hist(points, bucket_size; title="")
    hist = make_hist(points, bucket_size)
    x, y = collect(keys(hist)), collect(values(hist))
    bar(x, y, bar_width = bucket_size, title = title, show=true)
end

#=
Random.seed!(0)
#uniform between -100 to 100
@time uniform = [200 * rand(-100:100) for i in 1:10000]
#normal distribution with mean = 0 and standard deviation = 0.57
@time normal = [57*inverse_normal_cdf(rand()) for i in 1:10000]
plot_hist(uniform, 10; title = "Uniform Histogram")
#plot_hist(normal, 10; title = "Normal Histogram")
=#

#= #######################################################################################
    Two dimenisional Data

    Ex. daily average number of minutes user spends + years of data science experience
=# #######################################################################################

function rand_normal()
  """returns a random draw froma a standard normal distribution"""
  return inverse_normal_cdf(rand())
end

function plot_scatt()
  xs = [rand_normal() for i in 1:1000] 
  ys1 = [ (x + rand_normal())/2 for x in xs] 
  ys2 = [(-x + rand_normal())/2 for x in xs]
  println("xs: $xs\nys1: $ys1\nys2: $ys2")
  scatter!(xs, ys1, label="ys1", xlabel="xs", ylabel="ys", legend=true,title="Very Different Joint Distributions")
  scatter!(xs, ys2, label="ys2",show =true)
end
#plot_scatt()

#= #######################################################################################
    Many dimenisional Data
    
    lets think of a general way to correlate data to one another: Correlation Matrix
        *row i and column j are the correlations between ith dimension and jth dimension

=# ######################################################################################
function mean(x)
  return sum(x)/length(x)
end

function de_mean(x)
  """translate x by subtracting its mean (i.e mean = 0)"""
  xbar = mean(x)
  return [xi-xbar for xi in x]
end

function dot(v,w)
  """v1*w1 + v2*w2 + ... + vn*wn"""
  return sum(vi*wi for (vi,wi) in zip(v,w))
end

function sum_of_squares(v)
  """v1*v1 + v2*v2 + ... + vn*vn"""
  return dot(v,v)
end

function variance(x)
  """assumes x has at least two elements"""
  n = length(x)
  deviations = de_mean(x)
  return sum_of_squares(deviations)/(n-1)
end

function std_dev(x)
  return sqrt(variance(x))
end

function correlation(x,y)
  stdev_x = std_dev(x)
  stdev_y = std_dev(y)
  if stdev_x>0 && stdev_y>0
    return covariance(x,y)/stdev_x/stdev_y
  else
    return 0
  end
end

function get_column(A, j)
  return [Ai[j] for Ai in A]
end

function get_row(A, i)
  return A[i]
end

function make_matrix(numrows, numcolumns, entryfn)
  """returns a numrows x numcolumns matrix whose (i,j)th entry is entryfn(i,j)"""
  return [entryfn(i,j) for j in 1:numcolumns for i in 1:numrows]
end

function correlation_matrix(data)
  """return s the num columns x num_rows matrix whose (i,j)th entry is the correlation between the columns i and j of the data"""

  num_rows, num_columns = shape(data)
  println("num of rows: $num_rows\nnum of columns: $num_columns")
  function matrix_entry(i,j)
    return correlation(get_column(data, i), get_column(data,j))
  end
  return make_matrix(num_columns,num_columns, matrix_entry)
end

#= #######################################################################################
  Cleaning and Munging 
    *Real-world data is dirty. Often you’ll have to do some work on it before you can use it.
        ** list of parsers, each specifying how to parse one of the columns.

=# ######################################################################################

function parse_row(inputrow, parsers)
  """given a list of parsers apply approproate one to each element to inputrow"""
  return [parser(value)]
end

print("im alive but im dead")
readline()
