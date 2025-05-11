#!/bin/bash

#title           : check_top_pod_frappe_worker_default.sh
#description     : Script ini digunakan untuk memantau pod dengan prefix frappe-worker-default di namespace praktis-frappe. Jika pod tidak terdeteksi dalam output kubectl top pod, script akan menghapusnya secara paksa dengan kubectl delete pod --force --grace-period=0.
#author          : Rizki Permana
#==============================================================================

NAMESPACE="praktis-frappe"
POD_NAME_PREFIX="frappe-worker-default"

# Mendapatkan list pod yang sesuai dengan prefix
pods=$(kubectl get pods -n $NAMESPACE -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | grep "^$POD_NAME_PREFIX")

# Loop untuk memeriksa setiap pod
for pod in $pods; do

  # Mendapatkan waktu saat ini dalam format UTC+7
  current_time=$(TZ="Asia/Jakarta" date "+%Y-%m-%d %H:%M:%S %Z")

  # Memeriksa apakah pod terdeteksi di kubectl top pod
  if ! kubectl top pod "$pod" -n $NAMESPACE > /dev/null 2>&1; then
    echo "[$current_time] Pod $pod tidak terdeteksi di kubectl top pod. Menghapus pod..."

    # Menghapus pod dengan force dan grace period 0
    kubectl delete pod "$pod" -n $NAMESPACE --force --grace-period=0
  else
    echo "[$current_time] Pod $pod terdeteksi di kubectl top pod."
  fi
done