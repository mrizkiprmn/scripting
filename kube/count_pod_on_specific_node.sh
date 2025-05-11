#!/bin/bash

#title           : checking_pods_metabase.sh
#description     : Script untuk menghitung jumlah pod per node dalam node pool tertentu berdasarkan label yang ditentukan.
#author          : Rizki Permana
#==============================================================================

# Nama node pool sebagai variabel
NODEPOOL="praktis-dev"

# Ambil daftar node berdasarkan label app=$NODEPOOL
NODE_LIST=$(kubectl get nodes -l app=$NODEPOOL -o name | cut -d'/' -f2)

# Hitung jumlah pod per node yang ada dalam node pool tersebut
kubectl get pods -A -o jsonpath='{range .items[?(@.spec.nodeName)]}{.spec.nodeName}{"\n"}{end}' | grep -Fxf <(echo "$NODE_LIST") | sort | uniq -c | sort -rn