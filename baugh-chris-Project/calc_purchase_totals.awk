#!/usr/bin/awk
#Chris Baugh
# 11/24/23
# Project

#helper script to generate purchase totals by state and gender
# consolidate duplicate state purchase entries to one total per state
# assumes file already seperated by m/f
BEGIN {
    FS = ","
    OFS = ","
}
{
if (prev!=$1 && prev) {
    printf "%s,%s,%.3f\n", prev, $2, (prevSum?prevSum:"N/A")
    prev=prevSum=""
}
}
{
    prev=$1
    prevSum+=$3
}
END {
    if (prev)
    {
        printf "%s,%s,%.3f\n", prev, $2, (prevSum?prevSum:"N/A")
    }
}
