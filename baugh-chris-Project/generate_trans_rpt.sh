#!/bin/bash
#Chris baugh
#11/24/23
#Project

# helper script to create the transactions count per state
# cut out the state and make a temp file of only states, convert to uppper and sort
cut -f 12 -d ',' "transaction.csv" | tr [:lower:] [:upper:] | sort > "01_gen_trans_rpt.tmp"
#heading/title
printf "Report by: Chris baugh\n"
printf "Transaction Count Report\n\n"
printf "State      Transaction Count\n"
# call the awk script sorting on the count column
awk -f "generate_trans_rpt.awk" "01_gen_trans_rpt.tmp" | sort -k 2,2nr
exit 0
