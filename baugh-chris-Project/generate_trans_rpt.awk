#!/usr/bin/awk
#Chris Baugh
#11/24/23
#Project

#Helper script to generate transaction counts per state
BEGIN {
    FS ","
    OFS = ","
}
{#begin body
#store state as index and increment the associated value per occurence
counts[$1]++
}#end body
END {
    #Make it so by printing the array
    for (i in counts)
        printf ("%-10s %s\n", i, counts[i])
}
