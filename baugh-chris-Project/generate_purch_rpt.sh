#!/bin/bash
#Chris baugh
#11/24/23
#Project

# helper script to create the purchase report of totals by gender and state
# cut out state, purchas, gender, convert to uppper and sort
cut -f 12,5,6 -d ',' "transaction.csv" | tr [:lower:] [:upper:] | sort -t',' -k 3,3 > "01_gen_purch_rpt.tmp"
# separate into a male only and female only files
awk 'BEGIN {FS=","; OFS=","}
    {
        if ($1 ~ /F/) {print $3, $1, $2 > "02_fem_gen_purch_rpt.tmp"}
        else {print $3, $1, $2 > "02_mal_gen_purch_rpt.tmp"}
    }' < "01_gen_purch_rpt.tmp"
#create separate m/f purchase totals by state
awk -f "calc_purchase_totals.awk" "02_fem_gen_purch_rpt.tmp" > "03_fem_purch_totals.tmp"
awk -f "calc_purchase_totals.awk" "02_mal_gen_purch_rpt.tmp" > "03_mal_purch_totals.tmp"
# paste the 2 files together sorting on total descending
paste -d "\n\n" "03_fem_purch_totals.tmp" "03_mal_purch_totals.tmp" | sort -t',' -k 3,3nr > "04_paste_purch_totals.tmp"
#heading/title
printf "Report by: Chris Baugh\n"
printf "Purchase Summary Report\n\n"
printf "State      Gender     Report\n"
# call the awk script sorting on the count column
#awk -f "generate_trans_rpt.awk" "01_gen_trans_rpt.tmp" | sort -k 2,2nr
awk 'BEGIN{FS=","; OFS=","}{printf "%-10s %-10s %-5.2f\n", $1, $2, $3}' "04_paste_purch_totals.tmp"
exit 0
