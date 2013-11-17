#!/usr/bin/env python
# From: http://www.michael-noll.com/tutorials/writing-an-hadoop-mapreduce-program-in-python/

import sys
import math

# input comes from STDIN (standard input)
for line in sys.stdin:
    # remove leading and trailing whitespace
    line = line.strip()
    # split the line into words
    values = line.split('\t')
    trunc = [0,0]

    for i in range(0,2):
        trunc[i] = math.floor(10 * float(values[i])) / 10
    tempstr = str(trunc[0]) + ',' + str(trunc[0] + 0.1) + ',' + str(trunc[1]) + ',' + str(trunc[1] + 0.1)
    print '%s\t%s' % (tempstr, 1)
