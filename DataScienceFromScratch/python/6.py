#!/usr/local/bin/python2.7

from __future__ import division
import random
import math
from collections import Counter
import matplotlib
gui_env = ['pgf', 'Qt4Cairo', 'cairo', 'MacOSX', 'TkCairo', 'gdk', 'ps', 'GTKAgg', 'nbAgg', 'GTK', 'Qt5Agg', 'template', 'Qt5Cairo', 'WXCairo', 'GTK3Cairo', 'GTK3Agg', 'WX', 'Qt4Agg', 'TkAgg','agg', 'svg', 'GTKCairo', 'WXAgg', 'WebAgg', 'pdf']
matplotlib.use(gui_env[18]) #TkAgg
import matplotlib.pyplot as plt


##################################### Conditional Probability #################################
#two events E and F are independent according to the follwoing definition:
#P(E,F) = P(E)P(F)

#two dependent events are defined as the probability of E conditional on F:
#P(E|F) = P(E,F)/P(F) <-OR-> P(E,F) = P(E|F)P(F)

#Ex. A family with two unborn children
#   1.  Each child is equally likely to be a boy or girl
#   2.  The gender of the second child is independent of the gender of the first child

def random_kid():
    return random.choice(["boy","girl"])

def cond_prob():
    both_gorls = 0
    old_gorl = 0
    either_gorl = 0
    random.seed(0)

    for i in range(10000):
        young = random_kid()
        old = random_kid()
        if old == "girl":
            old_gorl+=1
        if old == "girl" and young == "girl":
            both_gorls+=1
        if old == "girl" or young == "girl":
            either_gorl+=1

    print "P(both | older):" , both_gorls/old_gorl #P(B|G) = P(B,G)/P(G) = P(B)/P(G) = 1/2
    print "P(both | either):" , both_gorls/either_gorl #P(B|L) = P(B,L)/P(L) = P(B)/P(L) = 1/3

#cond_prob()

########################################## Bayes Theorem ######################################

# Q) Want the probability of some event E conditional on some other event F occurring. 
# Cond) Only have the probability of F conditional on E occurring.
# A) P(E|F) = P(F|E)P(E)/[P(F|E)P(E) + P(F|!E)P(!E)]


###################################### Continuous Distributions ###############################

#uniform distribution puts equal weight on all the numbers between 0 and 1

#probability density function (pdf): the probability of seeing a value in a certain interval equals the integral of the density function over the interval.
def uniform_pdf(x):
    return 1 if x >=0 and x<1 else 0

#cumulative distribution function (cdf): the probability that a random variable is less than or equal to a certain value
def unform_cdf(x):
    """returns the probability that a uniform random variable is<=x"""
    if x<0: return 0
    elif x<1: return x
    else: return 1

####################################### Normal Distributions ##################################

#   Determined by two parameters: mean (mu) and standard deviation (sigma). 
#   The mean indicates where the bell is centered, and the standard deviation how wide it is

def normal_pdf(x, mu=0, sigma=1):
    sqrt_two_pi = math.sqrt(2*math.pi)
    return (math.exp(-(x-mu)**2/2/sigma**2)/(sqrt_two_pi*sigma))

def plot_pdf():
    xs = [x / 10.0 for x in range(-50, 50)]
    plt.plot(xs,[normal_pdf(x,sigma=1) for x in xs],'-',label='mu=0,sigma=1') 
    plt.plot(xs,[normal_pdf(x,sigma=2) for x in xs],'--',label='mu=0,sigma=2') 
    plt.plot(xs,[normal_pdf(x,sigma=0.5) for x in xs],':',label='mu=0,sigma=0.5') 
    plt.plot(xs,[normal_pdf(x,mu=-1) for x in xs],'-.',label='mu=-1,sigma=1') 
    plt.legend()
    plt.title("Various Normal pdfs")
    plt.show()
#plot_pdf()

def normal_cdf(x, mu=0,sigma=1):
    return (1 + math.erf((x - mu) / math.sqrt(2) / sigma)) / 2

def plot_cdf():
    xs = [x / 10.0 for x in range(-50, 50)]
    plt.plot(xs,[normal_cdf(x,sigma=1) for x in xs],'-',label='mu=0,sigma=1') 
    plt.plot(xs,[normal_cdf(x,sigma=2) for x in xs],'--',label='mu=0,sigma=2') 
    plt.plot(xs,[normal_cdf(x,sigma=0.5) for x in xs],':',label='mu=0,sigma=0.5') 
    plt.plot(xs,[normal_cdf(x,mu=-1) for x in xs],'-.',label='mu=-1,sigma=1') 
    plt.legend(loc=4) # bottom right
    plt.title("Various Normal cdfs")
    plt.show()
#plot_cdf()

def inverse_normal_cdf(p, mu=0, sigma=1, tolerance=0.00001): 
    """find approximate inverse using binary search"""

    # if not standard, compute standard and rescale
    if mu != 0 or sigma != 1:
        return mu + sigma * inverse_normal_cdf(p, tolerance=tolerance)
    low_z, low_p = -10.0, 0 # normal_cdf(-10) is (very close to) 0
    hi_z, hi_p = 10.0, 1 # normal_cdf(10)  is (very close to) 1 
    while hi_z - low_z > tolerance:
        mid_z = (low_z + hi_z) / 2 # consider the midpoint
        mid_p = normal_cdf(mid_z) # and the cdf's value there
        if mid_p < p:
            # midpoint is still too low, search above it
            low_z, low_p = mid_z, mid_p 
        elif mid_p > p:
            # midpoint is still too high, search below it
            hi_z, hi_p = mid_z, mid_p
        else:
            break 
    return mid_z


#################################### Central limit Theorem ####################################

#   Random variables identically distributed: taking average of independent variables is approximately normally distributed.

def bernoulli_trial(p):
    return 1 if random.random() < p else 0

def binomial(n, p):
    return sum(bernoulli_trial(p) for _ in range(n))

def make_hist(p, n, num_points):
    data = [binomial(n, p) for _ in range(num_points)]
    
    # use a bar chart to show the actual binomial samples
    histogram = Counter(data)
    plt.bar([x - 0.4 for x in histogram.keys()],
            [v / num_points for v in histogram.values()], 0.8,
            color='0.75')
          
    mu = p * n
    sigma = math.sqrt(n * p * (1 - p))
    # use a line chart to show the normal approximation
    xs = range(min(data), max(data) + 1)
    ys = [normal_cdf(i + 0.5, mu, sigma) - normal_cdf(i - 0.5, mu, sigma) 
            for i in xs] 
    plt.plot(xs,ys)
    plt.title("Binomial Distribution vs. Normal Approximation")
    plt.show()
make_hist(0.75,100,10000)
