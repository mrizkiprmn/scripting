#!/bin/sh

#title           : dump_by_table.sh
#description     : Skrip untuk melakukan backup satu tabel dari database MySQL, hasil dump nya upload ke S3, dan menghapus backup lama.
#author          : Rizki Permana
#==============================================================================

# Konfigurasi Zona
DATEFILE=$(TZ=Asia/Bangkok date -d tomorrow +%y%m%d)
OLDDATEFILE=$(TZ=Asia/Bangkok date --date="1 day ago" +%y%m%d)
CURDATEFILE=$(TZ=Asia/Bangkok date +%y%m%d)

# Konfigurasi Database
DB_HOST=""
DB_NAME=""
DB_USER=""
DB_PASSWORD=""
TABLE_NAME=""
TIMESTAMP_COLUMN=""

# S3
BUCKET_NAME="praktis-backup-rds-db"

echo "==========================================="| tee -a "$LOG_FILE"
echo "$(TZ=Asia/Bangkok date '+%Y-%m-%d %H:%M:%S') - PROSES DUMP TABLE" | tee -a "$LOG_FILE"
echo "==========================================="| tee -a "$LOG_FILE"
echo "Database   : ${DB_NAME}" | tee -a "$LOG_FILE"
echo "Tabel      : ${TABLE_NAME}" | tee -a "$LOG_FILE"
echo "Tanggal    : 20${DATEFILE}" | tee -a "$LOG_FILE"
echo "===========================================" | tee -a "$LOG_FILE"

# 1. Dump satu tabel (hanya data 30 hari terakhir)
BACKUP_FILE="/backup/${DB_NAME}_${TABLE_NAME}_${DATEFILE}.gz"
echo "$(TZ=Asia/Bangkok date '+%Y-%m-%d %H:%M:%S') - Memulai proses dump database..."
mysqldump -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" "$TABLE_NAME" \
  --single-transaction \
  --where="${TIMESTAMP_COLUMN} >= DATE_SUB(NOW(), INTERVAL 30 DAY)" | gzip > "$BACKUP_FILE"

if [ $? -eq 0 ]; then
  echo "$(TZ=Asia/Bangkok date '+%Y-%m-%d %H:%M:%S') - Backup berhasil disimpan di: $BACKUP_FILE" | tee -a "$LOG_FILE"
else
  echo "$(TZ=Asia/Bangkok date '+%Y-%m-%d %H:%M:%S') - Gagal melakukan backup database. Periksa konfigurasi dan koneksi ke MySQL." | tee -a "$LOG_FILE"
  exit 1
fi

# 2. Upload ke S3
S3_PATH="s3://${BUCKET_NAME}/jual/${DB_NAME}_${TABLE_NAME}_${DATEFILE}.gz"
echo "$(TZ=Asia/Bangkok date '+%Y-%m-%d %H:%M:%S') - Mengunggah backup ke S3..." | tee -a "$LOG_FILE"
aws s3 cp "$BACKUP_FILE" "$S3_PATH" > /dev/null 2>&1

if [ $? -eq 0 ]; then
  echo "$(TZ=Asia/Bangkok date '+%Y-%m-%d %H:%M:%S') - Backup berhasil diunggah ke S3: $S3_PATH" | tee -a "$LOG_FILE"
else
  echo "$(TZ=Asia/Bangkok date '+%Y-%m-%d %H:%M:%S') - Gagal mengunggah backup ke S3. Periksa koneksi internet dan izin akses." | tee -a "$LOG_FILE"
  exit 1
fi

# 3. Hapus backup lama
OLD_BACKUP_FILE="/backup/${DB_NAME}_${TABLE_NAME}_${OLDDATEFILE}.gz"
echo "$(TZ=Asia/Bangkok date '+%Y-%m-%d %H:%M:%S') - Mengecek dan menghapus backup lama..."
if [ -f "$OLD_BACKUP_FILE" ]; then
  rm -rf "$OLD_BACKUP_FILE"
  if [ $? -eq 0 ]; then
    echo "$(TZ=Asia/Bangkok date '+%Y-%m-%d %H:%M:%S') - Backup lama (20${OLDDATEFILE}) berhasil dihapus."
  else
    echo "$(TZ=Asia/Bangkok date '+%Y-%m-%d %H:%M:%S') - Gagal menghapus backup lama (20${OLDDATEFILE}). Periksa izin file."
  fi
else
  echo "$(TZ=Asia/Bangkok date '+%Y-%m-%d %H:%M:%S') - Tidak ada backup lama (20${OLDDATEFILE}) yang ditemukan untuk dihapus."
fi

echo "==========================================="
echo "$(TZ=Asia/Bangkok date '+%Y-%m-%d %H:%M:%S') - PROSES BACKUP SELESAI"
echo "==========================================="