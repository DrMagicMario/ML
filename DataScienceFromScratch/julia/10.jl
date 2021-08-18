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
    
    while hi_z - low_z > tolerance
        mid_z = (low_z + hi_z) / 2 # consider the midpoint
        mid_p = normal_cdf(mid_z) # and the cdf's value there
    if mid_p < p
        # midpoint is still too low, search above it
        low_z, low_p = mid_z, mid_p 
    elseif mid_p > p
        # midpoint is still too high, search below it
        hi_z, hi_p = mid_z, mid_p 
    else
        break
    end

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
    uniform between -100 to 100
    uniform = [200 * rand(-100:100) for i in 1:10000]
    #normal distribution with mean = 0 and standard deviation = 0.57
    normal = [57*inverse_normal_cdf(rand()) for i in 1:10000]
    #plot_hist(uniform, 10; title = "Uniform Histogram")
    plot_hist(normal, 10; title = "Normal Histogram")
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
  xs = [rand_normal() for _ in 1:1000] 
  ys1 = [ x + rand_normal() / 2 for x in xs] 
  ys2 = [-x + rand_normal() / 2 for x in xs]

  scatter!(xs, ys1, marker='.', color="black", label="ys1", xlabel="xs", ylabel="ys", legend=true,title="Very Different Joint Distributions", show=true)
end

print("im alive but im dead")
readline()
