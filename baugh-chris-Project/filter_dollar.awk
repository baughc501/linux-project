#!/usr/bin/awk
#Chris Baugh
#11/23/23
#Project

#Helper script to filter dollar sign from data
BEGIN {
    FS = ","
    OFS = ","
}
{#begin body
    #print purchase starting from index 2
    #skips the leading $
    $6 = substr($6,2)
    print
}
