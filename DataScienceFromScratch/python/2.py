#!/usr/local/bin/python2.7

#python2.7 uses int division by default
from __future__ import division #normal division

################################## whitespace formatting ####################################
#Whitespace is ignored inside parentheses and brackets
#You can also use a backslash to indicate that a statement continues onto the next line
def whitespace_formatting():
    for i in [1,2,3,4,5]:
        print i 
        for j in [1,2,3,4,5]:
            print j 
            print i + \
            j
        print i
    print "done"
    return

#whitespace_formatting()


################################## Modules ####################################
import matplotlib.pyplot as plt
import re as regex

#specific values from a module
from collections import defaultdict, Counter

lookup = defaultdict(int)
my_counter = Counter()
my_regex = regex.compile("[0-9]+", regex.I)

print lookup, my_counter, my_regex


################################## Functions ####################################
def double(x):
    """optional docstring that explains function purpose"""
    return x*2

#Functions are first-class: can assign them to variables and pass them into functions
def apply_func(f):
    """calls the function f with 1 as its argument"""
    return f(1)

my_double = double
x = apply_func(my_double) #passes 1 to double()
print x #2

#anon. funcs: You can assign lambdas to variables. Not typically used (can cause problems)
y = apply_func(lambda x: x+4)
print y #5
anon_double = lambda x: x*2 #wack
def another_double(x): return 2*x #better

#default args.
def my_print(message="my default message"):
    print message
#my_print()
#my_print("hello")

def subtract(a=0,b=0):
    return a-b
#print(subtract(10,5)) #5
#print(subtract(0,5)) #-5
#print(subtract(b=5)) #-5


################################## Strings ####################################
#delimited by mathcing single or double quotation marks
single_quote = 'data science'
double_quote = "data science"

#backslashes encodes special characters
tab_string = "\t"   #represents the tab character
print(len(tab_string))     # is 1

#to include backslashes: create raw string r""
not_tab = r"\t"
print(len(not_tab)) # is 2

multi_line = """This is the first line.
second line.
third line."""
print(multi_line)


################################## Exceptions ####################################
try:
    print 0/0
except ZeroDivisionError:
    print "cannot divide by zero"


################################## Lists ####################################
#lists are just ordered collections in python
int_list = [1,2,3]
hetero_list = ["string", 0.1 ,True]
list_of_list = [int_list, hetero_list, []]
print(len(int_list))    #3
print(sum(int_list))    #6

#indexing
def index_demo():
    x = range(10)   #list [0,1,...,9]
    zero = x[0]     #0, lists are 0-indexed
    one = x[1]      
    nine = x[-1]     
    eight = x[-2]    
    x[0] = -1 
    print zero, one, nine, eight, x
    return
#index_demo()

#list membership: checks all indexes (shouldnt use on large lists)
print 1 in [1,2,3], 0 in [1,2,3] #true, false

#concat
def concat_demo():
    x = [1,2,3]
    y = x + [4,5,6]
    print x, y
    x.extend([4,5,6]) #x ix now [1,2,3,4,5,6]
    print x
    x.append(0)
    print x
    return
#concat_demo()

#unpacking
def unpack_demo():
    x,y = [1,2] #ValueError thrown if the number of elements on both sides not equal.
    print x, y
    return

#unpack_demo()


################################## Tuples ####################################
#Immutable lists: specified by parentheses or nothing
def tuple_demo():
    mylist = [1,2]
    mytuple = (1,2)
    othertuple = 3,4
    mylist[1] = 3
    try:
        mytuple[1] = 3
        othertuple[1] = 3
    except TypeError:
        print "cannot modify tuples"
    print mylist, mytuple , othertuple
    return
#tuple_demo()

#return multiple values with tuples
def sum_and_product(x,y):
    return (x+y),(x*y)
print sum_and_product(2,3), sum_and_product(5,10) #(5,6), (15, 50)

#multiple assignment
x, y = 1,2
x, y = y, x
print x, y #2 1


################################## Dictionaries ####################################
#associates values with keys: quick retrieval of a value to a corresponding key
empty_dict = {}
empty_dict2 = dict()
grades = {"Joel": 80, "Tim": 95}

#indexing
def index_demo():
    joels_grade = grades["Joel"] #80
    #KeyError if key not in dict
    try:
        kates_grade = grades["Kate"]
    except KeyError:
        print "no grade for Kate"

    grades["Tim"] = 99
    grades["Kate"] = 100
    print grades
    return
#index_demo()

#list membership
print "Joel" in grades, "Kate" in grades
print grades.get("Joel",0), grades.get("Kate", 0)

#Counter: turns a sequence of values into a defaultdict(int)-like object mapping keys to counts.
from collections import Counter
c = Counter([0,1,2,0]) # {0:2, 1:1, 2:1}
print c

#Sets: collection of distinct elements - fast membership tests and finding distinct elems.
def Set_demo():
    s = set() 
    s.add(1) 
    s.add(2) 
    s.add(2)
    x = len(s) 
    y= 2 in s 
    z= 3 in s
    print s,x,y,z
    item_list = [1,2,3,1,2,3]
    item_set = set(item_list)
    print len(item_list), item_list, len(item_set), item_set
    return
#Set_demo()


################################## Control Flow ####################################
if 1 > 2:
    message = "if"
elif 1>3:
    message = "elif = else if"
else:
    message = "else"
print message

#ternary if-than-else
print  "even" if x%2 ==0 else "odd"

#while
x = 0 
while x < 10:
    print x, "is less than 10"
    x+=1

#for
for x in range(10):
    print x, "is less than 10"

#more complex logix: continue, break
for x in range(10):
    if x==3:
        continue #pass
    if x==5:
        break #break out of loop
    print x #1,2,4


################################## Truth ###############################

mybool = 1<2
mybool1 = True==False
print mybool, mybool1 #True, False

none = None
print none==None
print none is None

#python can "Boolify" anything: the following evaluate to False
"""
False
None
[] (an empty list) {} (an empty dict) ""
set()
0
0.0
"""
#practically everything else evals to True

#all: takes a list and returns True precisely when every element is truthy
#any: returns True when at least one element is truthy
print(all([True, 1, {3}]))
print(all([True, 1, {}]))
print(any([True, 1, {}]))
print(all([]))
print(any([]))


################################## Sorting ###############################

def sort_demo():
    x = [-4,1,-2,3]
    y = sorted(x)
    print x, y
    x.sort(key=abs) #aort list to a key
    y.sort(reverse=True) #largest to smallest
    print x, y
    return

#sort_demo()


################################## List Comprehensions ###############################

def listcomp_demo():
    #List
    even_numbers = [x for x in range(5) if x%2==0]
    squares = [x * x for x in range(5)] 
    even_squares = [x * x for x in even_numbers] 
	#Dicts
    square_dict = { x: x*x for x in range(5)} 
    square_set = {x*x for x in[1,-1]} 
	#Multiple Fors
    pairs = [(x,y) for x in range(10) for y in range(10)] 
    increasing_pairs = [(x,y) for x in range(10) for y in range(x+1,10)]
    print even_numbers, squares, even_squares, square_dict, \
square_set, pairs, increasing_pairs
    return 

#listcomp_demo()


###################### Generators and Iterators #########################

"""
Generator: something that you can iterate over but whose values are produced only as needed (lazily).

Can only iterate through generator once; will need to recreate generator eery time you need to traverse it
"""

#yield
def lazy_range(n):
	"""a lazy version of range"""
	i = 0
	while i<n:
		yield i
		print i
		i+=1
	return
#lazy_range(20)

#comprehensions wrapped in parentheses
lazy_below20 = (i for i in lazy_range(20) if 1%2==0)
#print lazy_below20


###################### Randomness #########################
import random 
def random_demo():
    uniform = [random.random() for i in range(4)]
    shuffled = range(10)
    random.shuffle(shuffled)
    bf = random.choice(["alice","bob","charlie"])
    winning_lotto = random.sample(range(60),6)
    forrand = [random.choice(range(10)) for i in range(4)]
    random.seed(10)
    print uniform, random.random(), random.randrange(10), \
    random.randrange(3,6), shuffled, bf, winning_lotto, forrand
    return 
#random_demo()


############################### Regex ###################################
print all([                                 
    not regex.match("a", "cat"),            # 'cat' doesnt start with 'a' 
    regex.search("a", "cat"),               # 'cat' has 'a' in it
    not regex.search("c", "dog"),           # 'dog' doesnt have 'c' in it
    3 == len(regex.split("[ab]", "carbs")), # split on a or b to [c,r,s]
    "R-D-" == regex.sub("[0-9]", "-", "R2D2")# replace digits with dashes
    ]) # prints True


############################### OOP ###################################
# by convention, we give classes PascalCase names
class Set:
       # these are the member functions
       # every one takes a first parameter "self" (another convention)
       # that refers to the particular Set object being used

    def __init__(self, values=None):
        """This is the constructor.
        It gets called when you create a new Set.
        You would use it like
        s1 = Set() # empty set
        s2 = Set([1,2,2,3]) # initialize with values"""
        self.dict = {}  # each instance of Set has its own dict property 
                        # which is what we'll use to track memberships
        if values is not None: 
            for value in values:
                self.add(value)

    def __repr__(self):
        """this is the string representation of a Set object if you type it at the Python prompt or pass it to str()""" 
        return "Set: " + str(self.dict.keys())
          
    #represent membership by being a key in self.dict with value True
    def add(self, value): 
        self.dict[value] = True
          
    # value is in the Set if it's a key in the dictionary
    def contains(self, value): 
        return value in self.dict
    
    def remove(self, value): 
        del self.dict[value]

s = Set([1,2,3])
s.add(4)
print s.contains(4) # True s.remove(3)
print s.contains(3) # False


########################## Functional Tools #############################

#manual partial
def exp(base, power): 
    return base ** power

def two_to_the(power):
    return exp(2, power)

#partial lib
from functools import partial
two_to_the = partial(exp, 2) # is now a function of one variable 
square_of = partial(exp, power=2)
print two_to_the(3), square_of(3) #8,9

#reduce, map filter
xs = [1, 2, 3, 4]
def multiply(x,y): return x*y
def is_even(x): return x%2==0
def rmf_test(): 
    twice_xs = [double(x) for x in xs] # [2, 4, 6, 8]
    map_xs = map(double, xs) # same as above
    list_doubler = partial(map, double) #function that doubles a list
    partial_xs = list_doubler(xs) # again [2, 4, 6, 8]
    products = map(multiply, [1,2], [4,5]) #map can do multiple args
    x_evens = [x for x in xs if is_even(x)] # [2, 4]
    filt_evens = filter(is_even, xs) # same as above
    list_evener = partial(filter, is_even) #function that filters a list
    partial_evens = list_evener(xs) # again [2, 4]
    x_product = reduce(multiply, xs) # = 1 * 2 * 3 * 4 = 24
    list_product = partial(reduce, multiply) #function that reduces a list
    partial_product = list_product(xs) # again = 24
    print twice_xs, map_xs, list_doubler, partial_xs, products, \
            x_evens, filt_evens, list_evener, partial_evens, \
            x_product, list_product, partial_product 
    return
#rmf_test()


########################## enumerate #############################
"""
for i, document in enumerate(documents):
    do_something(i, document)
"""


########################## Zip an Unpacking #############################
# Zip: transforms lists into a single list of tuples of corresponding elements
def zip_demo(): #zip stops as soon as the first list ends.
    list1 = ['a', 'b', 'c']
    list2 = [1, 2, 3]
    list3 = zip(list1, list2) 
    pairs = [('a', 1), ('b', 2), ('c', 3)]
    letters, numbers = zip(*pairs) #unzip
    unzip_raw = zip(('a', 1), ('b', 2), ('c', 3))
    print list3, letters, numbers, unzip_raw 
    return
#zip_demo()

#use argument unpacking anywhere!
def myadd(x,y): return x+y
print myadd(1,2), myadd(*[1,2])
try:
    myadd([1,2])
except TypeError:
    print "invalid arg type"


########################## Args and kwargs #############################

def doubler(f): 
    def g(x):
        return 2 * f(x) 
    return g

def f1(x): 
    return x + 1

#this wont work for an arbritrary number of arguments
g = doubler(f1)
print g(3) , g(-1)# 8 (== ( 3 + 1) * 2), 0 (== (-1 + 1) * 2)

#via unpacking
#args is a tuple of unnamed args; kwargs is a dict of named args
def magic(*args, **kwargs):
    print "unnamed args:", args 
    print "keyword args:", kwargs
    return 
magic(1, 2, key="word", key2="word2")


def other_way_magic(x, y, z): 
    return x + y + z
    
x_y_list = [1, 2]
z_dict = { "z" : 3 }
print other_way_magic(*x_y_list, **z_dict) # 6

