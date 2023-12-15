#!/bin/bash

# Lista todos os projetos
#PROJECTS=$(gcloud projects list --format="value(projectId)")
PROJECTS=servidores-homologacao

# Loop sobre cada projeto
for PROJECT_ID in $PROJECTS; do
    echo "Processando projeto: $PROJECT_ID"

    # Adicione o novo certificado
    NEW_CERTIFICATE_NAME="db-certificado-wildcard-diagnosticosdobrasil-2024"
    NEW_CERTIFICATE_FILE="/home/user/gcloud/wildcard_diagnosticosdobrasil_2024.crt"
    NEW_PRIVATE_KEY="/home/user/gcloud/privatedb.key"
    gcloud compute ssl-certificates create $NEW_CERTIFICATE_NAME --certificate=$NEW_CERTIFICATE_FILE --project=$PROJECT_ID --private-key=$NEW_PRIVATE_KEY

    # Obtenha a lista de todos os balanceadores de carga
    LB_NAMES=$(gcloud compute target-https-proxies list --project=$PROJECT_ID --format="value(name)")

    # Itere sobre cada balanceador de carga e atualize o certificado
    for LB_NAME in $LB_NAMES; do
        echo "Atualizando certificado para $LB_NAME..."
        gcloud compute target-https-proxies update $LB_NAME --ssl-certificates=$NEW_CERTIFICATE_NAME --project=$PROJECT_ID
    done

    echo "Projeto $PROJECT_ID concluído!"
done

echo "Processo concluído!"
