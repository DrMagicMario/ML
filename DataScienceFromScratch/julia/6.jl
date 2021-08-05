#!/usr/local/bin/julia

using Pkg
Pkg.activate("jenv")
Pkg.instantiate()

using Plots, Random
gr()

#= Ch. 6: Probability

  "Quantifying the uncertainty associated with events chosen from some universe of events"

  P(E) -> probability of event E occuring
=#

#= ############################## Dependence and Independence #################################
    *two events E and F are dependent if whether E happens gives us information about whether F happens

    *two events E and F are independent if the probability both happen is the product of the probabilities that each one happens: P(E,F) = P(E)P(F)
=#

#= ############################# Conditional Probabilities ####################################

  *probability that E happens, given F happens: P(E|F) = P(E,F)/P(F) -> P(E,F) = P(E|F)P(F) 
    ** if E and F are indepenedent then: P(E|F) = P(E)
      *** i.e. knowing F occurred gives us no additional information about whether E occurred

Ex. a family with two unborn children.
  1. Each child is equally likely to be a boy or a girl
  2. The gender of the second child is independent of the gender of the first child

B = "BOTH CHILDREN ARE GIRLS"
G = "THE OLDER CHILD IS A GIRL"
L = "AT LEAST ONE OF THE CHILDREN IS A GIRL"

Q1) P(B|G) = P(B,G)/P(G) = P(B)/P(G) = 1/2
Q2) P(B|L) = P(B,L)/P(L) = P(B)/P(L) = 1/3
=#

function random_kid()
  return rand(["boy","girl"])
end
#println("random kid: $(random_kid())")

function cond_prob()
  B,G,L = 0,0,0
  Random.seed!(69)
  for i in 1:10000
    young = random_kid()
    old = random_kid()
    if old == "girl"
      G+=1
    end
    if old == "girl" && young == "girl"
      B+=1
    end
    if old == "girl" || young == "girl"
      L+=1
    end
  end
  println("P(both | older): $(B/G)")
  println("P(both | either): $(B/L)")
end
#cond_prob()


#= ################################### Bayes' Theorem #########################################

  *a way of “reversing” conditional probabilities
    **Solving for E conditional on F given F conditional on E

    P(E|F) = P(E,F)/P(F) = P(F|E)P(E)/P(F)  , where P(F) = P(F,E) + P(F,!E)
    P(E|F) = P(F|E)P(E)/[P(F|E)P(E) + P(F|!E)P(!E)]

    Ex. - disease that affects 1 in every 10,000 people
        - there is a test for this disease that gives the correct result 99% of the time.

          T = "TEST IS POSITIVE", D = "HAVE DISEASE"

          P(T|D) = 0.99, P(D) = 0.0001, P(T|!D) = 0.01, P(!D) = 0.9999
          P(D|T) = P(T|D)P(D)/[P(T|D)P(D)+P(T|!D)P(!D)] = 0.98
=#

#= ################################### Random Variables #######################################

  *range of possible values according to a probability distribution
  *expected value: average of its values weighted by their probabilities
    **coin flip variable has an expected value of 1/2 (= 0 * 1/2 + 1 * 1/2)
    **range(10) variable has an expected value of 4.5.

=#

################################## Continuous Distributions #################################

#uniform distribution -> equal weight on values between 0 to 1 
#probability density function -> value in a range = integral of density function in that range

function uniform_pdf()
  """returns the probability that a uniform random variable is <= x"""
  if x<0 return 0 # uniform random is never less than 0
  elseif x<1 return x # e.g. P(x <= 0.4) = 0.4
  else return 1 # uniform random is always less than 1
  end
end


##################################### Normal Distributions ###################################
# mean (mu) = where the bell is centered
# standard deviation (sigma) = width of bell

function normal_pdf(x;mu=0,sigma=1)
  sqrt_two_pi = sqrt(2*pi)
  return (exp(-(x-mu)^2/2/sigma^2)/(sqrt_two_pi*sigma))
end

function plot_pdfs()
  xs = [x/10.0 for x in -50:50]
  plot(xs, [normal_pdf(x) for x in xs], label="mu=0,sigma=1", title="Various Normal PDFs", legend=true)
  plot!(xs,[normal_pdf(x;sigma=2) for x in xs], label="mu=0,sigma=2")
  plot!(xs,[normal_pdf(x;sigma=0.5) for x in xs], label="mu=0,sigma=0.5")
  plot!(xs,[normal_pdf(x;mu=-1) for x in xs], label="mu=-1,sigma=1", show=true)
end
#plot_pdfs()

using SpecialFunctions #erf
function normal_cdf(x; mu=0, sigma=1)
  return (1+erf((x-mu)/sqrt(2)/sigma))/2
end

function plot_cdf()
  xs = [x/10.0 for x in -50:50]
  plot(xs, [normal_cdf(x) for x in xs], label="mu=0,sigma=1", title="Various Normal CDFs", legend=true)
  plot!(xs,[normal_cdf(x;sigma=2) for x in xs], label="mu=0,sigma=2")
  plot!(xs,[normal_cdf(x;sigma=0.5) for x in xs], label="mu=0,sigma=0.5")
  plot!(xs,[normal_cdf(x;mu=-1) for x in xs], label="mu=-1,sigma=1", show=true)
end
#plot_cdf()

function inverse_normal_pdf(p;mu=0,sigma=1,tolerance=0.00001)
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
  end
  return mid_z
end


##################################### Central Limit Theorem ###################################


readline()
