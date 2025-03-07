#!/bin/bash

VM_NAME="gcp-svp-g5dbp03"
ZONE="southamerica-east1-a"
DATE="07-03-2025"
STORAGE_LOCATION="southamerica-east1" # Localização dos snapshots

gcloud config set project gbh-g5-database-prd

DISKS=$(gcloud compute instances describe $VM_NAME \
  --zone=$ZONE \
  --format="value(disks[].deviceName)")

# Loop 
for DISK in $(echo $DISKS | tr ';' '\n'); do
  echo "Criando snapshot do disk: $DISK no location $STORAGE_LOCATION"
  gcloud compute disks snapshot $DISK \
    --snapshot-names="${DISK}-snapshot-${DATE}" \
    --zone=$ZONE \
    --storage-location=$STORAGE_LOCATION
done
