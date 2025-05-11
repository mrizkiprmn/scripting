#!/bin/bash

#title           : checking_memory.sh
#description     : Skrip untuk memantau penggunaan memori server dan secara otomatis me-restart MySQL jika penggunaan memori lebih dari threshold yang ditentukan.
#author          : Wihadil Karyono
#==============================================================================

# Timezone
TZ="Asia/Jakarta"

# Set memory threshold (%)
THRESHOLD=84

# Log File
LOG_FILE="/var/log/checking_memory.log"

# Get total and used memory in percentage
MEMORY_USAGE=$(free | grep Mem | awk '{printf("%.0f", $3/$2 * 100)}')

# Check if memory usage exceeds threshold
if [ "$MEMORY_USAGE" -ge "$THRESHOLD" ]; then
    echo "$(TZ=$TZ date '+%Y-%m-%d %H:%M:%S'): Memori tinggi: ${MEMORY_USAGE}%. Restart MySQL Service..." >> $LOG_FILE
    systemctl restart mysql
    echo "$(TZ=$TZ date '+%Y-%m-%d %H:%M:%S'): MySQL service restarted." >> $LOG_FILE
else
    echo "$(TZ=$TZ date '+%Y-%m-%d %H:%M:%S'): Memory aman: ${MEMORY_USAGE}%. Tidak ada tindakan." >> $LOG_FILE
fi