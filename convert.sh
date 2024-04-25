#!/bin/bash

# Define the names of the CSV files and the output Excel file
csv_files=("subnets.csv" "ng_capacity.csv" "status_codes.csv")
excel_file="combined.xlsx"

# Create a new Excel file with the specified name
touch "$excel_file"

# Loop over the CSV files and convert them to Excel sheets
for csv_file in "${csv_files[@]}"
do
  # Get the name of the sheet from the CSV filename
  sheet_name=$(basename "$csv_file" .csv)

  # Convert the CSV file to an Excel sheet using `csvkit` (which must be installed)
  csv2xls "$csv_file" --sheet "$sheet_name" --output "$excel_file"
done
