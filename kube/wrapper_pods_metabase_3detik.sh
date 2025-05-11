#!/bin/bash

#title           : wrapper_pods_metabase_3detik.sh
#description     : Script ini menjalankan script checking_pods_metabase.sh sebanyak 20 kali dengan interval 3 detik antara setiap eksekusi.
#author          : Wihadil Karyono
#==============================================================================

for i in {1..20}; do
    /home/ubuntu/script-metabase/checking_pods_metabase.sh  # Jalankan script utama
    sleep 3
done