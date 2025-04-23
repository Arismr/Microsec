
**Purpose**

This script parses the strongSwan log (e.g., /var/log/secure) and prints out a summary of VPN activity. It can be used to validate handshake events before sending logs to Loki.

Script Content
---------------------------------------------------------------------------------
#!/usr/bin/env python3

import re
from collections import Counter

LOG_PATH = "/var/log/secure"

# Define patterns
patterns = {
    "established": re.compile(r'IPsec SA established'),
    "closed": re.compile(r'deleting IKE_SA'),
    "fail": re.compile(r'no proposal chosen'),
}

# Initialize counters
stats = Counter({"established": 0, "closed": 0, "fail": 0})

# Process the log file
with open(LOG_PATH, 'r') as f:
    for line in f:
        for label, pattern in patterns.items():
            if pattern.search(line):
                stats[label] += 1

# Output results
print("--- VPN Log Summary ---")
for key, count in stats.items():
    print(f"{key.title()}: {count}")
--------------------------------------------------------------------------------
**Usage**
--------------------------------------------------------------------------------
chmod +x parse-logs.py
./parse-logs.py
--------------------------------------------------------------------------------
Extend this script with argparse and date filters for production use.
