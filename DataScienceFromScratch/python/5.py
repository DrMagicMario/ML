#!/usr/local/bin/python2.7

from __future__ import division 
from collections import Counter
import random
import math
import matplotlib
gui_env = ['pgf', 'Qt4Cairo', 'cairo', 'MacOSX', 'TkCairo', 'gdk', 'ps', 'GTKAgg', 'nbAgg', 'GTK', 'Qt5Agg', 'template', 'Qt5Cairo', 'WXCairo', 'GTK3Cairo', 'GTK3Agg', 'WX', 'Qt4Agg', 'TkAgg', 'agg', 'svg', 'GTKCairo', 'WXAgg', 'WebAgg', 'pdf']
matplotlib.use(gui_env[18]) #TkAgg
import matplotlib.pyplot as plt

#############################################################################################
#                                       Statistics 
#############################################################################################

#Base dataset
random.seed(69) #lolz
num_friends = [random.randint(1,100) for x in range(101)]
friend_counts = Counter(num_friends)
xs = range(101)
ys = [friend_counts[x] for x in xs]

#visualization
def prob_view():
    plt.bar(xs,ys)
    plt.axis([0,101,0,25])
    plt.title("Histogram of Friend Counts")
    plt.xlabel("# of friends")
    plt.ylabel("# of people")
    plt.show()
#prob_view()

#Generating some statistics
num_points = len(num_friends)
maximum = max(num_friends)
minimum = min(num_friends)

#Alternatively
sorted_vals = sorted(num_friends)
smallest = sorted_vals[0]
second_smallest = sorted_vals[1]
second_biggest = sorted_vals[-2]

#print "Some Statistics:\nmin = %s\nmax = %s\nsecond largest = %s" % (minimum,maximum,second_biggest)

#################################### Central Tendencies #####################################

#mean (average) -> where is the data centered?
def mean(x):
    return sum(x)/len(x)
#print "mean num of friends: %s" % mean(num_friends)

#median -> middle-most value or average of two middle-most values (# of values is odd/even)
    # good at ignoring outliers 
def median(v):
    """finds middle-most value"""
    n = len(v)
    sorted_v = sorted(v)
    mid = n // 2 #int division

    if n%2 == 1:    #odd
        return sorted_v[mid]
    else:   #even
        lo = mid - 1
        hi = mid
        return (sorted_v[lo]+sorted_v[hi])/2
#print "median num of friends: %s" % median(num_friends)

#represents values less than which a certain percentile of the data lies
def quantile(x, p):
    """returns the pth-percentile value in x"""
    idx = int(p * len(x))
    return sorted(x)[idx]
#print "sample quantiles: 0.1 -> %s , 0.25 -> %s, 0.75 -> %s, 0.9 -> %s" % (quantile(num_friends, 0.1), quantile(num_friends, 0.25), quantile(num_friends, 0.75), quantile(num_friends, 0.90))

#most-common value[s]
def mode(x):
    """returns a list"""
    counts = Counter(x)
    Max = max(counts.values())
    return[x for x, count in counts.iteritems() if count == Max]
#print "mode: %s" % mode(num_friends)


#################################### Dispersion #####################################

#Range:measures how spread data is: 0 = no spread (same values) 
def dat_range(x):
    return max(x) - min(x)
#print "data range: %s" % dat_range(num_friends)

#Variance
def de_mean(x):
    """ translate x by subtracting its mean (result has mean = 0)"""
    xbar = mean(x)
    return [xi - xbar for xi in x]

def dot(v, w):
    """v_1 * w_1 + ... + v_n * w_n"""
    return sum(v_i * w_i for v_i, w_i in zip(v, w))

def sum_of_squares(v):
    """v_1 * v_1 + ... + v_n * v_n"""
    return dot(v, v)

#measures how a single variable deviates from its mean
def variance(x):
    """assumes x has at least two elements"""
    n = len(x)
    deviations = de_mean(x)
    return sum_of_squares(deviations)/(n-1)

def stddev(x): #standard deviation
    return math.sqrt(variance(x))

#print "variance num of friends: %s" % variance(num_friends)
#print "standard deviation num of friends: %s" % stddev(num_friends)

#more robust approach to dealing with outliers -> use a quartile!
def interquartile_range(x):
    return quantile(x, 0.75) - quantile(x, 0.25)
#print "interquartile range from 25-75 percent: %s" % interquartile_range(num_friends)


###################################### Correlation ####################################

#measures how two variables vary in tandem from their means
def covariance(x, y): 
    n = len(x)
    return dot(de_mean(x), de_mean(y)) / (n - 1) 
#print "Covariance num of friends: %s" % covariance(num_friends, daily_minutes) # 22.43

def correlation(x,y): #value always lies between -1 and 1
    stddev_x = stddev(x)
    stddev_y = stddev(y)
    if stddev_x > 0 and stddev_y > 0:
        return covariance(x,y)/stddev_x/stddev_y
    else:
        return 0 #no correlation
#print "Correlation betwwen num of friends and daily minutes: %s" % correlation(num_friends, daily_minutes)


