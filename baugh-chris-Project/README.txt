This project uses ONE driving script to be initially run with three arguments.
This script will call any other scripts needed.

Instructions for running etl.sh:
($0) file to run
($1) remote-server(server name or ip address)
($2) remote-userid
($3) remote-file path (search path for retrieving file)


USAGE: fileToRun serverName/ip userid filePath

EX1:
	./etl.sh class-srv cbaugh /home/shared/MOCK_MIX_v2.1.csv.bz2
EX2:
	./etl.sh 40.122.73.92 cbaugh /home/shared/some_other_file.csv.bz2

THANK YOU
