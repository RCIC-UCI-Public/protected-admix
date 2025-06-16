#! /bin/bash
#
# remove the specific requirement of specialized versions of libcufft, libcurand.  
# Other choice would be that the cuda-toolkit provides these specifically.
/usr/lib/rpm/find-requires $* | sed  \
    -e "/libn.*/d" \
    -e "/libacc.*/d" \
    -e "/libcu.*/d" \
    -e "/libmkl.*/d" \
    -e "/libmpi.*/d" \
    -e "/libopen.*/d" \
    -e "/libqd.*/d" \
    -e "/libscala.*/d" 
