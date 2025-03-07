#!/bin/bash

VM_NAME="gcp-svp-g5dbp03"
ZONE="southamerica-east1-a"
DATE="07-03-2025"
STORAGE_LOCATION="southamerica-east1" # Localização dos snapshots

gcloud config set project gbh-g5-database-prd

# Obter lista de discos
DISKS=$(gcloud compute instances describe $VM_NAME \
  --zone=$ZONE \
  --format="value(disks[].deviceName)")

# Loop para criar snapshots em paralelo
for DISK in $(echo $DISKS | tr ';' '\n'); do
  echo "Creating snapshot for disk: $DISK in location $STORAGE_LOCATION"
  gcloud compute disks snapshot $DISK \
    --snapshot-names="${DISK}-snapshot-${DATE}" \
    --zone=$ZONE \
    --storage-location=$STORAGE_LOCATION &
done

# Esperar todos os processos paralelos finalizarem
wait
echo "All snapshots have been created."
