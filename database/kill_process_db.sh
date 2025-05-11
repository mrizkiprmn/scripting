#!/bin/bash

#title           : kill_process_db.sh
#description     : Script ini memantau jumlah koneksi aktif ke MySQL/MariaDB dan secara otomatis me-restart jika jumlah koneksi melebihi threshold yang telah ditentukan
#author          : Wihadil Karyono
#==============================================================================

# Set the threshold for maximum connections
MAX_CONNECTIONS=130

# Get the current number of connections
CURRENT_CONNECTIONS=$(mysql -e "SHOW STATUS LIKE 'Threads_connected';" | grep 'Threads_connected' | awk '{print $2}')

# Log file path
LOG_FILE="/var/log/kill_process.log"

# Check if the current connections exceed the threshold
if [ "$CURRENT_CONNECTIONS" -ge "$MAX_CONNECTIONS" ]; then
    # Restart the MySQL service
    systemctl restart mariadb

    # Log the restart event with a timestamp
    echo "$(date +'%Y-%m-%d %H:%M:%S') - MySQL service restarted due to high number of connections: $CURRENT_CONNECTIONS" >> $LOG_FILE

fi