#!/usr/local/bin/python2.7

height_weight_age = [70, # inches
                    170, # pounds
                    40 ] # years

grades = [95,# exam1
          80,# exam2
          75,# exam3
          62 ] # exam4

def vector_add(v, w):
    """adds corresponding elements""" 
    return [v_i + w_i for v_i, w_i in zip(v, w)]

def vector_subtract(v, w):
    """subtracts corresponding elements""" 
    return [v_i - w_i for v_i, w_i in zip(v, w)]

def vector_sum(vectors):
    """sums all corresponding elements""" 
    result = vectors[0]                     #start with first vec
    for vector in vectors[1:]:              #then loop over rest
        result = vector_add(result, vector) #add to result
    return result

def vectorsum(vectors):
    return reduce(vector_add, vectors)

def scalar_multiply(c, v):
    """c is a number, v is a vector""" 
    return [c * v_i for v_i in v]

def vector_mean(vectors):
    """compute the vector whose ith element is the mean of the 
    ith elements of the input vectors"""
    n = len(vectors)
    return scalar_multiply(1/n, vector_sum(vectors))


def dot(v, w):
    """v_1 * w_1 + ... + v_n * w_n""" 
    return sum(v_i * w_i for v_i, w_i in zip(v, w))

def sum_of_squares(v):
    """v_1 * v_1 + ... + v_n * v_n""" 
    return dot(v, v)

import math
def magnitude(v):
    return math.sqrt(sum_of_squares(v))

def squared_distance(v, w):
    """(v_1 - w_1) ** 2 + ... + (v_n - w_n) ** 2""" 
    return sum_of_squares(vector_subtract(v, w))

def distance(v, w):
    return magnitude(vector_subtract(v, w))

A = [[1,2,3], #A has 2 rows and 3 columns 
    [4, 5, 6]]

B = [[1, 2], # B has 3 rows and 2 columns 
    [3, 4],
    [5, 6]]


def shape(A):
    num_rows = len(A)
    num_cols = len(A[0]) if A else 0 # number of elements in first row 
    return num_rows, num_cols

def get_row(A, i):
    return A[i] # A[i] is already the ith row

def get_column(A, j): # jth element of row A_i
    return [A_i[j] for A_i in A] # for each row A_i

def make_matrix(num_rows, num_cols, entry_fn):
    """returns a num_rows x num_cols matrix whose (i,j)th entry is entry_fn(i, j)"""
    return [[entry_fn(i, j)  # given i, create a list
            for j in range(num_cols)] # [entry_fn(i, 0), ... ] 
            for i in range(num_rows)] # create one list for each

def is_diagonal(i, j):
    """1's on the 'diagonal', 0's everywhere else"""
    return 1 if i == j else 0 

identity_matrix = make_matrix(5, 5, is_diagonal)
print A, B, identity_matrix



