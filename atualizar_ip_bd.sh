#!/bin/bash

# Variáveis
INSTANCE_ID="gcp-sqld-portal-representante"
PROJECT_ID="db-portal-repres-database-dev"
NETWORK_NAME="devops"
NEW_IP="45.189.164.89/32"
REQUEST_FILE="request.json"

# Obter token de acesso
ACCESS_TOKEN=$(gcloud auth print-access-token)

# Obter a configuração atual
EXISTING_IPS_JSON=$(curl -s -H "Authorization: Bearer $ACCESS_TOKEN" \
  "https://sqladmin.googleapis.com/v1/projects/$PROJECT_ID/instances/$INSTANCE_ID" \
  | jq '.settings.ipConfiguration.authorizedNetworks')

echo -e "CONFIGURAÇÃO ATUAL: \n$EXISTING_IPS_JSON"

# Atualizar o IP para o nome de rede existente e manter os outros
UPDATED_IPS_JSON=$(echo "$EXISTING_IPS_JSON" | jq -c \
  "map(if .name == \"$NETWORK_NAME\" then .value = \"$NEW_IP\" else . end)")

# Gerar o arquivo request.json no formato especificado
cat <<EOF > $REQUEST_FILE
{
  "settings": {
    "ipConfiguration": {
      "authorizedNetworks": $UPDATED_IPS_JSON
    }
  }
}
EOF

echo "Arquivo $REQUEST_FILE gerado com sucesso: "
cat $REQUEST_FILE | jq

# # Enviar a configuração atualizada
RESPONSE=$(curl -s -X PATCH \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json; charset=utf-8" \
  -d @$REQUEST_FILE \
  "https://sqladmin.googleapis.com/v1/projects/$PROJECT_ID/instances/$INSTANCE_ID")

echo "Resposta da API: $RESPONSE"
