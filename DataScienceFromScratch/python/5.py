#!/usr/local/bin/python2.7

from __future__ import division 
from collections import Counter
import random
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
print "mode: %s" % mode(num_friends)


#################################### Dispersion #####################################
