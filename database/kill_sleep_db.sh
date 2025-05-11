#!/bin/bash

#title           : kill_sleep.sh
#description     : Script ini memantau dan menghentikan proses MySQL yang berada dalam status Sleep lebih lama dari threshold yang ditentukan. Jika ada proses yang memenuhi kriteria, script akan mengeksekusi perintah KILL secara otomatis
#author          : Rizki Permana
#==============================================================================

# Konfigurasi database
MYSQL_USER=""
MYSQL_PASSWORD=""
MYSQL_HOST=""
MYSQL_DB=""
SLEEP_THRESHOLD=
LOG_FILE=""

# Dapatkan waktu saat ini dalam UTC+7
TIMESTAMP=$(TZ='Asia/Jakarta' date +"%Y-%m-%d %H:%M:%S")

# Ambil perintah KILL dalam satu query menggunakan GROUP_CONCAT
KILL_COMMAND=$(mysql -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" -h"$MYSQL_HOST" -se "
    SELECT GROUP_CONCAT(CONCAT('KILL ', id, ';') SEPARATOR ' ') 
    FROM information_schema.processlist 
    WHERE command = 'Sleep' AND db='$MYSQL_DB' AND time > $SLEEP_THRESHOLD;
")

# Jika ada proses yang harus di-kill
if [ -n "$KILL_COMMAND" ]; then
    mysql -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" -h"$MYSQL_HOST" -e "$KILL_COMMAND"
    
    if [ $? -eq 0 ]; then
        echo "$TIMESTAMP - Sukses Kill Proses Sleep di database $MYSQL_DB: $KILL_COMMAND" >> "$LOG_FILE"
    else
        echo "$TIMESTAMP - Gagal mengeksekusi KILL command: $KILL_COMMAND" >> "$LOG_FILE"
    fi
else
    echo "$TIMESTAMP - Tidak ada proses Sleep yang perlu dibunuh di database $MYSQL_DB." >> "$LOG_FILE"
fi