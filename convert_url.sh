#!/bin/bash

# Script para converter diretamente uma URL do PlantUML para PNG
# Autor: Tiago N. Pinto Silva
# Versão: 1.0.0

# Verificar se curl está instalado
if ! command -v curl &> /dev/null; then
  echo "❌ [ERRO] curl não está instalado. Por favor, instale curl."
  exit 1
fi

# Definir URL padrão se nenhuma for fornecida
PLANTUML_URL=${1:-"https://www.plantuml.com/plantuml/uml/SyfFKj2rKt3CoKnELR1Io4ZDoSa70000"}
OUTPUT_DIR=${2:-"output"}

# Extrair o código da URL
URL_CODE=$(echo "$PLANTUML_URL" | grep -oE 'uml/[^/]+' | cut -d'/' -f2)
echo "Código extraído da URL: $URL_CODE"

# Criar diretório de saída se não existir
mkdir -p "$OUTPUT_DIR"

# Converter diretamente para PNG usando a API do PlantUML
echo "Convertendo o diagrama diretamente para PNG..."
DOWNLOAD_URL="https://www.plantuml.com/plantuml/png/$URL_CODE"
OUTPUT_FILE="$OUTPUT_DIR/diagram_from_url.png"

curl -s "$DOWNLOAD_URL" --output "$OUTPUT_FILE"

# Verificar se o arquivo foi gerado
if [ -f "$OUTPUT_FILE" ]; then
  echo "✅ [SUCESSO] Diagrama convertido para PNG com sucesso!"
  echo "📝 Arquivo gerado: $OUTPUT_FILE"
  
  # Exibir tamanho do arquivo
  FILE_SIZE=$(du -h "$OUTPUT_FILE" | cut -f1)
  echo "📊 Tamanho do arquivo: $FILE_SIZE"
else
  echo "❌ [ERRO] Falha ao converter o diagrama."
  echo "Verifique se a URL está correta: $PLANTUML_URL"
  exit 1
fi

echo "Para visualizar o arquivo, abra-o com seu visualizador de imagens favorito."
