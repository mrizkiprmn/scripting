#!/bin/bash

#title           : wrapper_3detik.sh
#description     : Script ini menjalankan script utama sebanyak 20 kali dengan interval 3 detik antara setiap eksekusi.
#author          : Wihadil Karyono
#==============================================================================

for i in {1..20}; do
    /root/checking_memory.sh  # Jalankan script utama
    sleep 3
done