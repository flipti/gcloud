#!/bin/bash

# Função para exibir o menu de seleção
show_menu() {
  echo "Escolha um Cluster para logar:"
  echo "1. GKE DEV"
  echo "2. GKE HOM"
  echo "3. GKE PRD"
  echo "4. Sair"
}

# Loop para exibir o menu e lidar com a escolha
while true; do
  show_menu
  read -p "Opção: " choice

  case $choice in
    1)
      echo "Executando GKE DEV"
      # Insira o comando que deseja executar para a opção 1 aqui
      gcloud auth list
      gcloud config set project db-gke-dev
      gcloud container clusters get-credentials db-gke-dev --region=southamerica-east1
      gcloud compute ssh db-gke-dev-bastion --project=db-gke-dev --zone=southamerica-east1-a -- -L 8887:localhost:8888
      ;;
    2)
      echo "Executando GKE HOM"
      # Insira o comando que deseja executar para a opção 2 aqui
      gcloud auth list
      gcloud config set project db-gke-hom
      gcloud container clusters get-credentials db-gke-hom --region=southamerica-east1
      gcloud compute ssh db-gke-hom-bastion --project=db-gke-hom --zone=southamerica-east1-a -- -L 8888:localhost:8888
      ;;
    3)
      echo "Executando GKE PRD"
      # Insira o comando que deseja executar para a opção 2 aqui
      gcloud auth list
      gcloud config set project db-gke-prd
      gcloud container clusters get-credentials db-gke-prd --region=southamerica-east1
      gcloud compute ssh db-gke-prd-bastion --project=db-gke-prd --zone=southamerica-east1-a -- -L 8889:localhost:8888

      ;;  
    4)
      echo "Saindo do script"
      break
      ;;
    *)
      echo "Opção inválida. Escolha 1, 2 , 3 ou 4."
      ;;
  esac
done

