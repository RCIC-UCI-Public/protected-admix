#!/bin/bash
#
# remove erroneous requirements

/usr/lib/rpm/find-requires $* | sed \
    -e '/libmkl_/d' \
    -e '/libacc/d' \
    -e '/libcuda/d' \
    -e '/libmkl_/d' \
    -e '/libnv/d' 

# last 4 entries are for cuda-enabled version
    #-e '/\.*libmkl_intel_/d' \
