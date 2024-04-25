#!/bin/bash

# Define the output file name
output_file="merged_file.xlsx"

# Create a new Excel file with the first CSV file
csv_file="subnets.csv"
excel_file="$(echo $csv_file | cut -d '.' -f 1).xlsx"
ssconvert $csv_file $excel_file
mv "$excel_file" "$output_file"

# Add the remaining CSV files as new sheets in the Excel file
for csv_file in status_codes.csv ng_capacity.csv
do
    excel_file="$(echo $csv_file | cut -d '.' -f 1).xlsx"
    ssconvert $csv_file $excel_file
    xlsx2csv -i "$excel_file" -s 1 >> "$output_file"
done

# # Clean up the temporary Excel files
# rm file1.xlsx file2.xlsx file3.xlsx
