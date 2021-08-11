#!/usr/local/bin/julia

using Pkg
Pkg.activate("jenv")
Pkg.instantiate()

using Plots, Random, Distances
gr()

#=
Chapter 8: Gradient Descent (GD) returns a vector indicating the sharpest increase

    Motivation -> The "best" model usually minimizes error or maximizes likelihood of data
    Purpose -> pick a random point, calculate the GD and move towards (maximize) or opposite (minimize) of the vector.

    Pros:
        *good at solving from scratch

    Cons: 
        *does not work well with functions that have multiple local minima/maxima
            **better options may exist which requires multiple starting points
=#

#function to optimize
function sum_of_squares(v)
  """computes the sum of squared elements v"""
  return sum(vi^2 for vi in v)
end

#= estimating Gradient Descent

    *derivative at a point x measures how f(x) changes when we change x. 
        **defined as the limit of the difference quotients
=#
function diff_quot(f,x;h=0.00001) #as h approaches 0
  return (f(x+h)-f(x))/h
end

function square(x)
  return x*x
end

function derivative(x)
  return 2*x
end

#=
    cant find limits in computers since its a concept, instead estimate derivatives by evaluating the difference quotient for a very small e
=#
function derivative_plot()
  x = -10:10
  derivative_estimate = 
  plot(x, derivative(x), label="Actual", title="Actual Derivatives vs. Estimates",show=true)
  plot!(x, diff_quot.(square,x), label="Estimate",show=true,legend=true)
end
#derivative_plot()

#=
    if the function has many variables than we need to calculate PARTIAL derivatives
        *how f changes when we make small changes in just one of the input variables.
=#

function partial_difference_quotient(f,v,i,h)
  """compute the ith partial difference quotient of f at v"""
  w = [vj + (j==1 ? 1 : 0) for (j,vj) in enumerate(v)]
  return (f(w)-f(v))/h
end

#can computationally intensive: 2n 
function grad_est(f,v;h=0.00001)
  return [partial_difference_quotient(f,v,i,h) for (i,n) in enumerate(v)]
end

#=
    Using the Gradient: to minimize a function pick a random starting point and then take tiny steps in the opposite direction of the gradient until we reach a point where the gradient is very small

=#

function step(v,direction,step_size)
  """move step_size in direction from v"""
  return [vi + step_size * d for (vi,d) in zip(v,direction)]
end

function sum_of_squares_grad(v)
  return [2*vi for vi in v]
end

function minimize_func()
  #pick random starting point
  v = [rand(-10:10) for i in 1:3]
  tolerance = 0.0000001
  while true
    gradient = sum_of_squares_grad(v)
    next_v = step(v, gradient, -0.01)
    if euclidean(next_v,v) < tolerance
      break
    end
    v = next_v
  end
  println("$v")
end
#minimize_func()


#=
    Choosing Step Size:
        *fixed step size
        *gradually shrinking step sizes -> [100,10,1,0.1,0.01,0.001,0.0001,0.00001]
        *calculate step size that minimizes value of function (computationally instensive)
=#



#sometimes step size can lead to invalid results
function safe(f)
  """return a function similar to f; outputs infinity when f produces an error"""
  function safe_f(args...;kwargs...)
    try
      return f(args...;kwargs...)
    catch e
      return Inf
    end
    return safe_f
  end
end


#=
    Putting it all Together
        * we have some target_fn that we want to minimize, and we also have its gradient_fn
        * a starting value for the parameters theta_0
=#

function minimize_batch(target_fn,gradient_fn,theta_0;tolerance=0.000001)
  """use gradient descent to find theta that minimizes target function"""
  step_sizes = [100,10,1,0.1,0.01,0.001,0.0001,0.00001]
  theta = theta_0               #set theta to init val.
  target_fn = safe(target_fn)   #safe version of target_fn
  value = target_fn(theta)      #value to minimize

  while true
    gradient = gradient_fn(theta)
    next_thetas = [step(theta,gradient,-step_sz for step_sz in step_sizes)]

    #choose min
    next_theta = minimum(target_fn, next_thetas)
    next_value = target_fn(next_theta)

    #Stop if converging
    if abs(value-next_value) < tolerance
      return theta
    else
      theta, value = next_theta, next_value
    end
  end
end

#maximizing function
function negate(f)
  """return a function that for any input x returns -f(x)"""
  return x -> -f(args...;kwargs...)
end

function negate_all(f)
  """the same when f returns a list of numbers"""
  return x -> [-y for y in f(args...;kwargs...)]
end

function maximize_batch(target_fn,gradient_fn,theta_0;tolerance=0.000001)
  return minimize_batch(negate(target_fn), negate_all(gradient_fn),theta_0;tolerance=0.000001)
end

#=
    *each gradient step computation for the whole data set, which takes a long time.
    *Typically predictive error is simply the sum of the predictive errors for each data point.
        ** apply stochastic gradient descent, which computes one step for one point at a time.
=#

#iterate in random order
function randomize(data)
  """generator that returns the element s of data in random order"""
  idxs = [i for (i,n) in enumerate(data)]  #list of indexes
  shuffle!(idxs)
  return idxs
end

function minimize_stochastic(target_fn, gradient_fn, x, y, theta_0, alpha_0=0.01)
  theta, data, alpha = theta_0 , zip(x,y), alpha_0
  min_theta, min_value = nothing, Inf
  wack_iter = 0

  #100 iterations are wack, stop
  while wack_iter<100
    value = sum(target_fn(xi,yi,theta) for (xi,yi) in data)

    if value<min_value
      #if new min, svae and reset step_size
      min_theta, min_value = theta, value
      wack_iter = 0
      alpha = alpha_0
    else
      #not improving, shrink step size
      wack_iter+=1
      alpha*=0.9
    end

    for (xi,yi) in randomize(data)
      gradient_i = gradient_fn(xi,yi,theta)
      theta = theta .- (alpha .* gradient_i)
    end
  end
  return min_theta
end

function maximize_stochastic(target_fn, gradient_fn,x,y,theta_0;alpha_0=0.01)
  return minimize_stochastic(negate(target_fn),negate_all(gradient_fn),x,y,theta_0,alpha_0)
end

println("im alive but im dead")
readline()
