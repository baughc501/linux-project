#!/bin/bash
# Chris Baugh
# 11/19/23
# Semester Project

# Script to access a remote server, download a file, 
# extract the file, get the purchase data in a useable form, 
# normalize the data, create a summary of the purchase data, 
# generate a report with number of transactions by state, and
# generate a report of amount of purchases by gender and state.

#added so .tmp files aren't deleted if error occurs
set -o errexit
set -o pipefail

# arg checks
# Check for correct number of args
if [ $# -ne 3 ]
    then
        echo "Usage: remote-server remote-userid remote-file " 1>&2
        exit 1
fi
#check for correct file extension
if ! [[ $3 =~ \.csv\.bz2 ]]
    then
        echo "Third parameter extension requires .csv.bz2" 1>&2
        exit 1
fi
#check arg $1 for IP address
#if ! [[ $1 =~ [0-9]+\.[0-9]+\.[0-9]+\.[0-9]+ ]]
#    then
#        echo "Usage: First parameter must be an IP address" 1>&2
#        exit 1
#fi

# variables
server_location="$1"
userid="$2"
src_file_path="$3"
file_compressed=""
file_extracted=""

# Let's get started
printf "Gathering required files...\n"
#1 download the file ending in '.csv.bz2'
#scp "$userid@$server_location: $src_file_path/*\.csv\.bz2" .
scp "$userid@$server_location: $src_file_path" .
printf "1) Importing the transaction file from $src_file_path -- complete\n"

# set the compressed file name
#file_compressed=$(ls *\.csv\.bz2)
file_compressed="$(basename $src_file_path)"

#2 unzip the file
bunzip2 $file_compressed
file_extracted="${file_compressed%.*}"
#check if download is a file
if [ ! -f "$file_extracted" ]
    then
        echo "ERROR: file downloaded is not a normal file" 1>&2
        exit 1
fi
printf "2) Unzipping file $file_compressed -- complete\n"

#3 remove the header
tail -n +2 "$file_extracted" > "01_rm_header.tmp"
printf "3) Remove header from $file_extracted -- complete\n"

#4 convert all text to lowercase
tr '[:upper:]' '[:lower:]' < "01_rm_header.tmp" > "02_to_lower.tmp"
printf "4) Convert all uppercase in $file_extracted to lowercase -- complete\n"

#5 convert gender column to normalized data(m,f,u)
# calls external awk script
awk -f "conv_gender.awk" "02_to_lower.tmp" > "03_conv_gender_awk.tmp"
printf "5) Convert all gender choices in $file_extracted to m,f,u -- complete\n"

#6 filter out records with no state column value or NA
awk -f "filter_state.awk" "03_conv_gender_awk.tmp"
printf "6) Filter out missing and NA state values from $file_extracted and create exceptions.csv -- complete\n"

#7 remove dollar sign from purchase amount column
awk -f "filter_dollar.awk" "04_filter_state_awk.tmp" > "05_rm_dollar_awk.tmp"
printf "7) Remove dollar sign from purchase amount column in $file_extracted -- complete\n"

#8 Create transaction.csv sorted by cust id
sort -k 1,1 -k 6,6n -t',' "05_rm_dollar_awk.tmp" > "transaction.csv"
printf "8) Create transaction.csv file from $file_extracted sorted by customer id -- complete\n"

#9 Create the summary
# step 1: consolidate and sum
awk -f "pre_sort_create_summary.awk" "transaction.csv" > "06_pre_sort_summary.tmp"
# step 2 sort summary
sort -t',' -k 2,2 -k 3,3nr -k 4,4 -k 5,5 "06_pre_sort_summary.tmp" > "summary.csv"
printf "9) Generate a sorted summary.csv file from transaction.csv file -- complete\n"

#10a generate transaction report of tranaction counts per state
#call the bash script for this
./generate_trans_rpt.sh > "transaction.rpt"
printf "10a) Generate transaction report of purchase counts per state -- complete\n"

#10b generate purchase report of total purchases by gender and state
./generate_purch_rpt.sh transaction.csv > "purchase.rpt"
printf "10b) Generate purchase report of total purchases per state and gender -- complete\n"

#remove any temp files
rm -f *.tmp
printf "12) All temporary files have been removed and all files generated\n"
printf "THANK YOU\n"
exit 0
