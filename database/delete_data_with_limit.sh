#!/bin/bash

DB_HOST="host"
DB_USER="user"
DB_PASS="pass"
DB_NAME="db name"
TABLE_NAME="table name"
COLUMN_NAME="Timestamp"
LIMIT="100"
LOG_FILE="/var/log/script.log"

export TZ="Asia/Jakarta"
START_TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
START_TIME=$(date +%s)

echo "--------------- START EXECUTION ---------------" >> "$LOG_FILE"
echo "$START_TIMESTAMP - Start delete: $START_TIME" >> "$LOG_FILE"

ROW_COUNT_BEFORE=$(mysql -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASS" -D"$DB_NAME" -se "SELECT COUNT(id) FROM $TABLE_NAME;")
echo "Total Row Before: $ROW_COUNT_BEFORE" >> "$LOG_FILE"

if [ "$ROW_COUNT" -eq 0 ]; then
  echo "$START_TIMESTAMP - No more rows to delete." >> "$LOG_FILE"
else

  echo "$START_TIMESTAMP - Deleting $LIMIT rows..." >> "$LOG_FILE"
  mysql -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASS" -D"$DB_NAME" -e "DELETE FROM $TABLE_NAME ORDER BY $COLUMN_NAME ASC LIMIT $LIMIT;"
fi

END_TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
END_TIME=$(date +%s)
DURATION=$(( (END_TIME - START_TIME) / 60 ))

echo "--------------- FINISH EXECUTION ---------------" >> "$LOG_FILE"
echo "$END_TIMESTAMP - Done: Delete $LIMIT" >> "$LOG_FILE"
echo "$END_TIMESTAMP - Finish delete: $END_TIME" >> "$LOG_FILE"
echo "Total Execution: $DURATION menit" >> "$LOG_FILE"

ROW_COUNT_AFTER=$(mysql -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASS" -D"$DB_NAME" -se "SELECT COUNT(id) FROM $TABLE_NAME;")
echo "Total Row After: $ROW_COUNT_AFTER" >> "$LOG_FILE"