**Purpose**

This script performs simple log rotation to prevent disk space overuse by large or outdated strongSwan logs in /var/log/secure. It can be scheduled via cron.

Script Content
----------------------------------------------------------------------------------------
    #!/bin/bash
    
    # Define log file
    LOG_FILE="/var/log/secure"
    ROTATE_DIR="/var/log/ipsec-archive"
    DATE=$(date +"%Y-%m-%d_%H-%M-%S")
    
    # Create archive directory if it doesn't exist
    mkdir -p "$ROTATE_DIR"
    
    # Copy current log and clear the original
    cp "$LOG_FILE" "$ROTATE_DIR/secure-$DATE.log"
    cat /dev/null > "$LOG_FILE"
    
    # Optional: Remove archived logs older than 7 days
    find "$ROTATE_DIR" -type f -name "secure-*.log" -mtime +7 -exec rm {} \;
---------------------------------------------------------------------------------------
**Usage**
---------------------------------------------------------------------------------------
Make the script executable:

    chmod +x /path/to/rotate-logs.sh

Schedule via cron:

sudo crontab -e

Add this line to rotate logs every day at 1:00 AM:

0 1 * * * /path/to/rotate-logs.sh
---------------------------------------------------------------------------------------
Ensure the script path is correctly set in your crontab. This helps prevent logs from overwhelming Loki and keeps /var/log clean.
