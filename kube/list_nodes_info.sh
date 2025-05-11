#!/bin/bash

#title           : checking_pods_metabase.sh
#description     : Script untuk menampilkan informasi setiap node dalam cluster Kubernetes, termasuk jumlah pod yang berjalan, status node, jenis instance, dan node pool.
#author          : Rizki Permana
#==============================================================================

# Header output
echo "Node Name | Node Pool | Pod Count | Node Status | Instance Type"
echo "--------------------------------------------------------------"

# Ambil daftar semua node
NODE_LIST=$(kubectl get nodes -o name | cut -d'/' -f2)

# Loop untuk setiap node
for node in $NODE_LIST; do
    # Hitung jumlah pod yang berjalan di node ini
    pod_count=$(kubectl get pods -A --field-selector spec.nodeName="$node" --no-headers | wc -l)
    
    # Ambil status node (Ready / NotReady)
    node_status=$(kubectl get node "$node" -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}')
    
    # Ambil instance type
    instance_type=$(kubectl get node "$node" -o jsonpath='{.metadata.labels.node\.kubernetes\.io/instance-type}')

    # Ambil node pool (menggunakan label misalnya `karpenter.sh/nodepool`, bisa disesuaikan)
    node_pool=$(kubectl get node "$node" -o jsonpath='{.metadata.labels.karpenter\.sh/nodepool}')

    # Tampilkan hasilnya
    echo "$node | ${node_pool:-N/A} | $pod_count | $node_status | $instance_type"
done