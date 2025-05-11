#!/bin/bash

#title           : check_supervisorctl_wmsqueue.sh
#description     : Script ini digunakan untuk mengecek status Supervisor dalam deployment wms-queue-job-scheduler di namespace praktis-simpan menggunakan kubectl exec.
#author          : Rizki Permana
#==============================================================================

# Set the namespace and deployment name
NAMESPACE="praktis-simpan"
DEPLOYMENT_NAME="wms-queue-job-scheduler"

LOG_FILE="/home/ubuntu/cron.log"

export TZ="Asia/Jakarta"

echo "===== START: $(date) (UTC+7) =====" >> $LOG_FILE

# Execute the supervisorctl command in the pod
kubectl exec -n $NAMESPACE deploy/$DEPLOYMENT_NAME -- supervisorctl status

echo "===== END: $(date) (UTC+7) =====" >> $LOG_FILE


# Log retention: keep logs for only 1 day based on timestamp
# Get current date and time in seconds since epoch
current_time=$(date +%s)

# Loop through each START line in the log file
while IFS= read -r line; do
    if [[ $line == "===== START: "* ]]; then
        # Extract timestamp from the line
        log_time=$(echo "$line" | sed 's/===== START: \(.*\) (UTC+7) =====/\1/')

        # Convert log timestamp to seconds since epoch
        log_time_epoch=$(date -d "$log_time" +%s)

        # Check if the log entry is older than 1 day (86400 seconds)
        if (( (current_time - log_time_epoch) > 86400 )); then
            # Remove lines between START and END of this log entry
            sed -i "/$log_time/,/===== END:/d" $LOG_FILE
        fi
    fi
done < <(grep "===== START:" $LOG_FILE)