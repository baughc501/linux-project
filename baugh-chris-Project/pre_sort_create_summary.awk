#!/usr/bin/awk
#Chris Baugh
# 11/24/23
# Project

#helper script: step one=pre sort summary
# consolidate duplicate purchase entries to one total per customer
# rearrange the columns
BEGIN {
    FS = ","
    OFS = ","
}
{
if (prev!=$1 && prev) {
    print prev, $12, $13, $3, $2, (prevSum?prevSum:"N/A")
    prev=prevSum=""
}
}
{
    prev=$1
    prevSum+=$6
}
END {
    if (prev)
    {
        print prev, $12, $13, $3, $2, (prevSum?prevSum:"N/A")
    }
}
