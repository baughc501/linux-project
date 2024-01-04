#!/usr/bin/awk
#Chris baugh
#11/23/23
#Project

#Helper script to filter state data
BEGIN {
    FS = ","
    OFS = ","
}
{#body beginning
if ($12 == "" || $12 == "na")
{
    print > "exceptions.csv"
}
else
{
    print > "04_filter_state_awk.tmp"
}
}#end body
