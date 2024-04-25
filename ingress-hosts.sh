#URLs List
URLS=(`kubectl get ing --all-namespaces | awk '{ print $4 }' | tail -n +2`)
#Declaration of csv file
OUTPUT_FILE="status_codes.csv"
#Remove the file if it already exists
rm -rf $OUTPUT_FILE
#Initialization of csv file
echo "HOST,Status_Codes" >> $OUTPUT_FILE
#Capture the status
for URL in "${URLS[@]}"; do
  STATUS_CODE=$(curl -I "$URL" -o /dev/null -w "%{http_code}\n")
  echo "$URL,$STATUS_CODE" >> "$OUTPUT_FILE"
done



