#!/usr/local/bin/python2.7

from __future__ import division
import random

def random_kid():
    return random.choice(["boy","girl"])

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


print "P(both | older):" , both_gorls/old_gorl
print "P(both | either):" , both_gorls/either_gorl

