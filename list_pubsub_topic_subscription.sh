#!/bin/bash

# Verifica se o gcloud CLI está instalado
if ! command -v gcloud &> /dev/null; then
    echo "gcloud CLI não encontrado. Por favor, instale antes de executar este script."
    exit 1
fi

# Obtém a lista de projetos disponíveis na conta ativa
PROJECTS=$(gcloud projects list --format="value(projectId)")

# Verifica se há projetos disponíveis
if [ -z "$PROJECTS" ]; then
    echo "Nenhum projeto foi encontrado na conta ativa."
    exit 1
fi

echo "Iniciando a listagem de tópicos do Pub/Sub para todos os projetos..."

# Itera sobre todos os projetos
for PROJECT in $PROJECTS; do
    echo "-----------------------------------"
    echo "Projeto: $PROJECT"
    echo "-----------------------------------"
    
    # Configura o projeto atual no gcloud
    gcloud config set project "$PROJECT" --quiet

    # Lista os tópicos do Pub/Sub para o projeto atual
    TOPICS=$(gcloud pubsub topics list --format="value(name)")
    
    if [ -z "$TOPICS" ]; then
        echo "Nenhum tópico encontrado no projeto $PROJECT."
    else
        echo "Tópicos no projeto $PROJECT:"
        echo "$TOPICS"
    fi
done

echo "-----------------------------------"
echo "Listagem concluída."
