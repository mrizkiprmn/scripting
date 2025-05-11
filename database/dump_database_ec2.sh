#!/bin/sh

#title           : dump_database_ec2.sh
#description     : Skrip untuk melakukan backup dari database MySQL, hasil dump nya upload ke S3, dan menghapus backup lama.
#author          : Wihadil Karyono
#==============================================================================

DATEFILE=$(TZ=Asia/Bangkok date -d tomorrow +%y%m%d)
OLDDATEFILE=$(TZ=Asia/Bangkok date --date="1 day ago" +%y%m%d)
CURDATEFILE=$(TZ=Asia/Bangkok date --date= +%y%m%d)

mysqldump kerja --single-transaction | gzip > /backup/kerja$DATEFILE.gz
aws s3 cp /backup/kerja$DATEFILE.gz s3://backup-ec2-db/kerja/kerja$DATEFILE.gz

mysqldump wms_queue --single-transaction | gzip > /backup/wmsq$DATEFILE.gz
aws s3 cp /backup/wmsq$DATEFILE.gz s3://backup-ec2-db/wmsq/wmsq$DATEFILE.gz

mysqldump blibli_service --single-transaction | gzip > /backup/blibli_service$DATEFILE.gz
aws s3 cp /backup/blibli_service$DATEFILE.gz s3://backup-ec2-db/blibli_service/blibli_service$DATEFILE.gz

mysqldump jubelio_service --single-transaction | gzip > /backup/jubelio_service$DATEFILE.gz
aws s3 cp /backup/jubelio_service$DATEFILE.gz s3://backup-ec2-db/jubelio_service/jubelio_service$DATEFILE.gz

mysqldump lazada_service --single-transaction | gzip > /backup/lazada_service$DATEFILE.gz
aws s3 cp /backup/lazada_service$DATEFILE.gz s3://backup-ec2-db/lazada_service/lazada_service$DATEFILE.gz

mysqldump odoo_service --single-transaction | gzip > /backup/odoo_service$DATEFILE.gz
aws s3 cp /backup/odoo_service$DATEFILE.gz s3://backup-ec2-db/odoo_service/odoo_service$DATEFILE.gz

mysqldump openapi_service --single-transaction | gzip > /backup/openapi_service$DATEFILE.gz
aws s3 cp /backup/openapi_service$DATEFILE.gz s3://backup-ec2-db/openapi_service/openapi_service$DATEFILE.gz

mysqldump sellinall_service --single-transaction | gzip > /backup/sellinall_service$DATEFILE.gz
aws s3 cp /backup/sellinall_service$DATEFILE.gz s3://backup-ec2-db/sellinall_service/sellinall_service$DATEFILE.gz

mysqldump shopee_service --single-transaction | gzip > /backup/shopee_service$DATEFILE.gz
aws s3 cp /backup/shopee_service$DATEFILE.gz s3://backup-ec2-db/shopee_service/shopee_service$DATEFILE.gz

mysqldump shopify_service --single-transaction | gzip > /backup/shopify_service$DATEFILE.gz
aws s3 cp /backup/shopify_service$DATEFILE.gz s3://backup-ec2-db/shopify_service/shopify_service$DATEFILE.gz

mysqldump tiktok_service --single-transaction | gzip > /backup/tiktok_service$DATEFILE.gz
aws s3 cp /backup/tiktok_service$DATEFILE.gz s3://backup-ec2-db/tiktok_service/tiktok_service$DATEFILE.gz

mysqldump tokopedia_service --single-transaction | gzip > /backup/tokopedia_service$DATEFILE.gz
aws s3 cp /backup/tokopedia_service$DATEFILE.gz s3://backup-ec2-db/tokopedia_service/tokopedia_service$DATEFILE.gz

mysqldump tokotalk_service --single-transaction | gzip > /backup/tokotalk_service$DATEFILE.gz
aws s3 cp /backup/tokotalk_service$DATEFILE.gz s3://backup-ec2-db/tokotalk_service/tokotalk_service$DATEFILE.gz

mysqldump woocommerce_service --single-transaction | gzip > /backup/woocommerce_service$DATEFILE.gz
aws s3 cp /backup/woocommerce_service$DATEFILE.gz s3://backup-ec2-db/woocommerce_service/woocommerce_service$DATEFILE.gz

mysqldump billing --single-transaction | gzip > /backup/billing$DATEFILE.gz
aws s3 cp /backup/billing$DATEFILE.gz s3://backup-ec2-db/billing/billing$DATEFILE.gz

#rm -rf /backup/dealhook$OLDDATEFILE.gz 
rm -rf /backup/kerja$OLDDATEFILE.gz 
rm -rf /backup/wmsq$OLDDATEFILE.gz 
rm -rf /backup/blibli_service$OLDDATEFILE.gz
rm -rf /backup/jubelio_service$OLDDATEFILE.gz
rm -rf /backup/lazada_service$OLDDATEFILE.gz
rm -rf /backup/odoo_service$OLDDATEFILE.gz
rm -rf /backup/openapi_service$OLDDATEFILE.gz
rm -rf /backup/sellinall_service$OLDDATEFILE.gz
rm -rf /backup/shopee_service$OLDDATEFILE.gz
rm -rf /backup/shopify_service$OLDDATEFILE.gz
rm -rf /backup/tiktok_service$OLDDATEFILE.gz
rm -rf /backup/tokopedia_service$OLDDATEFILE.gz
rm -rf /backup/tokotalk_service$OLDDATEFILE.gz
rm -rf /backup/woocommerce_service$OLDDATEFILE.gz
rm -rf /backup/billing$OLDDATEFILE.gz
