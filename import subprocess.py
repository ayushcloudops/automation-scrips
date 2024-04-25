import subprocess
import requests

# URLs List
output = subprocess.check_output(["kubectl", "get", "ing", "--all-namespaces"])
URLS = [line.split()[3] for line in output.decode().split("\n")[1:-1]]

# Declaration of csv file
OUTPUT_FILE = "status_codes.csv"

# Remove the file if it already exists
subprocess.run(["rm", "-rf", OUTPUT_FILE], check=True)

# Initialization of csv file
with open(OUTPUT_FILE, "w") as f:
    f.write("HOST,Status_Codes\n")

# Capture the status
for URL in URLS:
    r = requests.head(URL)
    STATUS_CODE = r.status_code
    with open(OUTPUT_FILE, "a") as f:
        f.write(f"{URL},{STATUS_CODE}\n")
