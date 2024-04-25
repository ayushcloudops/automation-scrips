#!/bin/bash

# Convert CSV files to XLSX format
ssconvert ng_capacity.csv file1.xlsx
ssconvert status_codes.csv file2.xlsx
ssconvert subnets.csv file3.xlsx

# Merge XLSX files into a single file
xlsx2csv -i file1.xlsx,file2.xlsx,file3.xlsx combined.xlsx

# Remove temporary XLSX files
# rm file1.xlsx file2.xlsx file3.xlsx
