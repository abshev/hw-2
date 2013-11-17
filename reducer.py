#!/usr/bin/env python


import sys

current_coord = None
current_count = 0
coord = None
for line in sys.stdin:
    line = line.strip()
    coord, count = line.split('\t', 1)
    try:
        count = int(count)
    except ValueError:
        continue
    if current_coord == coord:
        current_count += count
    else:
        if current_coord:
            # write result to STDOUT
            print '%s,%s' % (current_coord, current_count)
        current_count = count
        current_coord = coord

if current_coord == coord:
    print '%s,%s' % (current_coord, current_count)
