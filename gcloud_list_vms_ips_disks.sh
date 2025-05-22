#EXECUTE O SCRIPT COM O PARAMETRO YES , EXEMPLO : yes y | ./script
#O SCRIPT GERA UM .CSV

#!/bin/bash

# Nome do arquivo CSV de saída
OUTPUT_FILE="instances_with_disks_all_projects.csv"

# Cabeçalho do CSV
echo "Projeto,Nome da Instância,IP Interno,IP Externo,Discos" > $OUTPUT_FILE

# Obter a lista de todos os projetos
PROJECTS=$(gcloud projects list --format="value(projectId)")

# Iterar por todos os projetos
for PROJECT in $PROJECTS; do
  echo "Definindo o projeto: $PROJECT"
  gcloud config set project $PROJECT

  # Obter a lista de instâncias no projeto
  INSTANCES=$(gcloud compute instances list --format="csv[no-heading](name,zone,networkInterfaces[0].networkIP,networkInterfaces[0].accessConfigs[0].natIP)")

  # Verificar se há instâncias no projeto
  if [[ -z "$INSTANCES" ]]; then
    echo "Nenhuma instância encontrada no projeto $PROJECT"
    continue
  fi

  # Iterar por todas as instâncias no projeto
  while IFS=',' read -r INSTANCE_NAME ZONE INTERNAL_IP EXTERNAL_IP; do
    # Obter os detalhes dos discos
    DISK_DETAILS=$(gcloud compute instances describe "$INSTANCE_NAME" --zone="$ZONE" --format="json" | jq -r '.disks[] | "\(.deviceName): \(.diskSizeGb) GB"' | paste -sd ";" -)

    # Verificar se há discos
    if [[ -z "$DISK_DETAILS" ]]; then
      DISK_DETAILS="Nenhum disco encontrado"
    fi

    # Linha formatada
    LINE="$PROJECT,$INSTANCE_NAME,$INTERNAL_IP,$EXTERNAL_IP,\"$DISK_DETAILS\""

    # Exibir no console
    echo "$LINE"

    # Adicionar os dados ao arquivo CSV
    echo "$LINE" >> $OUTPUT_FILE
  done <<< "$INSTANCES"
done

echo "CSV gerado em: $OUTPUT_FILE"
