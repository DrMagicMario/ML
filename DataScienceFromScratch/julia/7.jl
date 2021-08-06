#!/usr/local/bin/julia

using Pkg
Pkg.activate("jenv")
Pkg.instantiate()

using Plots, Random, SpecialFunctions
gr()

#= Ch. 7: Hypothesis and Inference

  Statistical Hypothesis and Testing
    *hypotheses are assertions like "people prefer Python to R” -> turned into statistics
      **H0 represents some default position
      **H1 to compare H0 with
    *use statistics to decide whether we can reject H0 as false or not


  Ex. H0 = “this coin is fair” => p = 0.5 | H1 = "this coin is not fair" => p != 0.5
=#

#Each coin flip is a bernoulli trial -> Binomial which approx. well with normal distribution
function normal_approx_to_binomial(n,p)
  """finds mu and sigma corresponding to Binomial(n,p)"""
  mu = p*n
  sigma = sqrt(p*(1-p)*n)
  return mu, sigma
end

#Normal distribution = normal_cdf!
function normal_cdf(x; mu=0, sigma=1)
  return (1+erf((x-mu)/sqrt(2)/sigma))/2
end

########### probabilities that realized values lie within (or outside) an interval ###########
below(hi;mu=0,sigma=1) = normal_cdf(hi;mu=0,sigma=1) #below a threshold
above(lo;mu=0,sigma=1) = 1-normal_cdf(lo;mu,sigma) #above a threshold
#random variable between lo and hi
between(lo,hi;mu=0,sigma=1) = normal_cdf(hi;mu,sigma) - normal_cdf(lo;mu,sigma)
#random variable outside range in general
outside(lo,hi;mu=0,sigma=1) = 1 - between(lo,hi;mu,sigma)

################ find regions around a mean accouting for likelihood #########################
function inverse_normal_cdf(p;mu=0,sigma=1,tolerance=0.00001)
  """find approximate inverse using binary search"""

  #if not standard, compute standard and rescale
  if mu!=0 || sigma!=1
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

#cutoffs for upper/lower/tail bounds within a percentage
upBound(prob; mu=0,sigma=1) = inverse_normal_cdf(prob; mu, sigma)
loBound(prob; mu=0,sigma=1) = inverse_normal_cdf(1-prob; mu, sigma)

function sidedBound(prob; mu=0,sigma=1)
  tail = (1-prob)/2
  upper = loBound(tail;mu,sigma)
  lower = upBound(tail;mu,sigma)
  return lower,upper
end

################################### testing hypotheses #######################################


function test_hypotheses()
  mu0, sigma0 = normal_approx_to_binomial(1000,0.5) #50, 15.8
  @show mu0;@show sigma0

  #signifigance: rejecting false positives set to %1-5 | rejected H0 even though it was true
  lo,hi = sidedBound(0.95; mu=mu0,sigma=sigma0) #(469,531)
  @show lo,hi

  #power: rejecting false negatives | accepted H0 even though it was false
  mu1,sigma1 = normal_approx_to_binomial(1000,0.55) #p = 0.55, biased to heads
  power = 1 - between(lo,hi;mu=mu1,sigma=sigma1) #0.887
  @show mu1; @show sigma1;@show power;

  #assume we hypothesis p <= 0.5 for heads: use a one-sided test i.e. reject P > 0.5 
  high = upBound(0.95;mu=mu0,sigma=sigma0)
  power2 = 1 - below(high;mu=mu0,sigma=sigma0)
  @show high;@show power2
end
test_hypotheses()

function two_sided_test(x;mu=0,sigma=1)
  if x >= mu #tail is greater than x
    return 2*above(x;mu,sigma)
  else #tail is less than x
    return 2*below(x;mu,sigma)
  end
end
mu0, sigma0 = normal_approx_to_binomial(1000,0.5) #50, 15.8
println("two sided test: $(two_sided_test(529.5;mu=mu0,sigma=sigma0))")
