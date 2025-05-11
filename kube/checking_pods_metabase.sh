#!/bin/bash

#title           : checking_pods_metabase.sh
#description     : Script untuk memantau pod Metabase di Kubernetes, memeriksa penggunaan memori, dan menghapus pod yang melebihi batas memori threshold ditentukan.
#author          : Rizki Permana
#==============================================================================

NAMESPACE="metabase"
POD_PREFIX="^metabase-" # Awali dengan metabase-
EXCLUDE_PREFIX="^metabase-management-" # Kecualikan metabase-management-
MEMORY_LIMIT_MB=2700 # Batas memori dalam MB

# Path to kubectl
KUBECTL="/usr/local/bin/kubectl"
# Path to log file
LOGFILE="/home/ubuntu/log/checking_pods_metabase.log"

# TIMEZONE ASIA/JAKARTA
export TZ="Asia/Jakarta"

# Get the list of pods with the specified prefix and exclude specific pods
PODS=$($KUBECTL get pods -n $NAMESPACE -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | grep "$POD_PREFIX" | grep -v "$EXCLUDE_PREFIX")

# Iterate over each pod
for POD in $PODS; do

  # Log in start time
  START_TIME=$(date '+%Y-%m-%d %H:%M:%S')
  echo "Start Time: $START_TIME" | tee -a $LOGFILE

  # Get the memory usage of the pod in raw format (e.g., 500Mi, 1Gi)
  MEMORY_USAGE_RAW=$($KUBECTL top pod $POD -n $NAMESPACE --no-headers | awk '{print $3}')

  # Extract numeric value and unit (e.g., 500 Mi, 1 Gi)
  MEMORY_VALUE=$(echo "$MEMORY_USAGE_RAW" | grep -o '[0-9]\+')
  MEMORY_UNIT=$(echo "$MEMORY_USAGE_RAW" | grep -o '[A-Za-z]\+')

  # Convert memory usage to MB for display and comparison
  if [ "$MEMORY_UNIT" = "Gi" ]; then
    MEMORY_IN_MB=$((MEMORY_VALUE * 1024))
  elif [ "$MEMORY_UNIT" = "Mi" ]; then
    MEMORY_IN_MB=$MEMORY_VALUE
  else
    MEMORY_IN_MB=0
  fi

  # Display current memory usage
  echo "Current memory usage : ${MEMORY_IN_MB}MB" | tee -a $LOGFILE

  # Check if memory usage exceeds the set limit
  if [ "$MEMORY_IN_MB" -gt "$MEMORY_LIMIT_MB" ]; then
    echo "Memory usage for pod $POD is greater than ${MEMORY_LIMIT_MB}Mi. Deleting the pod..." | tee -a $LOGFILE
    $KUBECTL delete pod $POD -n $NAMESPACE --grace-period=0 --force | tee -a $LOGFILE
  else
    echo "Memory usage is under control." | tee -a $LOGFILE
  fi

  # Log End Time
  END_TIME=$(date '+%Y-%m-%d %H:%M:%S')
  echo "End Time: $END_TIME" | tee -a $LOGFILE
done