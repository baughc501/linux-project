#!/usr/bin/awk
#Chris Baugh
#11/23/23
#Project
#Helper program for filtering gender data entries
# 1:f, 0:m, male:m, female:f, other:u
BEGIN {
    FS = ","
    OFS = ","
}#beginning of body
{
if ($5 ~ /1/ || $5 ~ /female/)
{
    $5 = "f"; print
}
else if ($5 ~ /0/ || $5 ~ /male/)
{
    $5 = "m"; print
}
else if ($5 !~ /m/ || $5 !~ /f/)
{
    $5 = "u"; print
}
else
{
    print
}
}#end of body

