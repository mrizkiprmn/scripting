#!/bin/bash

#title           : restart_mysql_on_memory.sh
#description     : Skrip untuk memantau penggunaan memori server dan secara otomatis me-restart MySQL jika penggunaan memori lebih dari threshold yang ditentukan.
#author          : Rizki Permana
#==============================================================================

# Ambil total dan penggunaan memori
total_mem=$(free -m | awk '/^Mem:/ {print $2}')
used_mem=$(free -m | awk '/^Mem:/ {print $3}')

# Hitung persentase penggunaan memori
mem_usage=$((used_mem * 100 / total_mem))

# Tentukan batas penggunaan memori
threshold=83

# Tentukan lokasi log
log_file="/var/log/mysql_restart.log"

# Periksa apakah penggunaan memori mencapai atau melebihi ambang batas
if [ "$mem_usage" -ge "$threshold" ]; then
    echo "$(date) - Memori tinggi: ${mem_usage}%. Merestart MySQL..." | tee -a "$log_file"
    systemctl restart mysql
    echo "$(date) - MySQL telah direstart." | tee -a "$log_file"
else
    echo "$(date) - Memori aman: ${mem_usage}%. Tidak ada tindakan yang diambil." | tee -a "$log_file"
fi