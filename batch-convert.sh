#!/bin/bash

# batch-convert.sh - Script para converter múltiplos arquivos PlantUML de uma vez
# Autor: Tiago N. Pinto Silva
# Versão: 1.0.0

# Pasta onde os PNGs serão salvos (padrão: ./output)
OUTPUT_DIR="${1:-./output}"
# Pasta com os arquivos de origem (padrão: ./examples)
INPUT_DIR="${2:-./examples}"
# Flag de verbosidade
VERBOSE=0

# Função para exibir mensagem de ajuda
show_help() {
  echo "Uso: $(basename $0) [DIRETÓRIO_SAÍDA] [DIRETÓRIO_ENTRADA] [--verbose]"
  echo
  echo "Converte todos os arquivos .wsd do diretório de entrada para PNG"
  echo
  echo "Parâmetros:"
  echo "  DIRETÓRIO_SAÍDA   Diretório onde os PNGs serão salvos (padrão: ./output)"
  echo "  DIRETÓRIO_ENTRADA Diretório de onde os arquivos .wsd serão lidos (padrão: ./examples)"
  echo "  --verbose         Exibe informações detalhadas durante o processamento"
  echo
  echo "Exemplos:"
  echo "  $(basename $0)                       # Usa ./examples como entrada e ./output como saída"
  echo "  $(basename $0) ./diagramas           # Usa ./examples como entrada e ./diagramas como saída"
  echo "  $(basename $0) ./diagramas ./src     # Usa ./src como entrada e ./diagramas como saída"
  echo "  $(basename $0) ./diagramas ./src --verbose  # Modo verboso"
  echo
  exit 0
}

# Verifica a presença de --help
for arg in "$@"; do
  if [[ "$arg" == "--help" || "$arg" == "-h" ]]; then
    show_help
  fi
  if [[ "$arg" == "--verbose" || "$arg" == "-v" ]]; then
    VERBOSE=1
  fi
done

# Verifica se o diretório de entrada existe
if [ ! -d "$INPUT_DIR" ]; then
  echo "❌ Erro: O diretório de entrada '$INPUT_DIR' não existe."
  exit 1
fi

# Cria o diretório de saída se não existir
mkdir -p "$OUTPUT_DIR"

# Caminho completo do script plantuml2png.sh
SCRIPT_DIR=$(dirname "$(realpath "$0")")
PLANTUML_SCRIPT="$SCRIPT_DIR/plantuml2png.sh"

# Verifica se o script plantuml2png.sh existe
if [ ! -f "$PLANTUML_SCRIPT" ]; then
  echo "❌ Erro: O script plantuml2png.sh não foi encontrado em '$SCRIPT_DIR'."
  exit 1
fi

# Adiciona permissão de execução ao script se necessário
chmod +x "$PLANTUML_SCRIPT"

# Encontra todos os arquivos .wsd no diretório de entrada
WSD_FILES=$(find "$INPUT_DIR" -name "*.wsd" -type f)

# Verifica se encontrou arquivos
if [ -z "$WSD_FILES" ]; then
  echo "⚠️ Aviso: Nenhum arquivo .wsd encontrado no diretório '$INPUT_DIR'."
  exit 0
fi

# Contador de arquivos
TOTAL_FILES=$(echo "$WSD_FILES" | wc -l)
CURRENT=0
SUCCESS=0
FAILED=0

echo "🔍 Encontrados $TOTAL_FILES arquivos .wsd para conversão"
echo "📁 Diretório de saída: $OUTPUT_DIR"
echo "🚀 Iniciando processamento..."

# Processa cada arquivo
for wsd_file in $WSD_FILES; do
  CURRENT=$((CURRENT + 1))
  FILENAME=$(basename "$wsd_file")
  
  echo "[$CURRENT/$TOTAL_FILES] Processando $FILENAME..."
  
  # Define as opções com base na verbosidade
  OPTS=""
  if [ $VERBOSE -eq 1 ]; then
    OPTS="--verbose"
  fi
  
  # Executa a conversão
  "$PLANTUML_SCRIPT" $OPTS --output-dir "$OUTPUT_DIR" "$wsd_file"
  
  # Verifica o resultado
  if [ $? -eq 0 ]; then
    SUCCESS=$((SUCCESS + 1))
    echo "✅ [$CURRENT/$TOTAL_FILES] $FILENAME convertido com sucesso"
  else
    FAILED=$((FAILED + 1))
    echo "❌ [$CURRENT/$TOTAL_FILES] Falha ao converter $FILENAME"
  fi
  
  echo "-------------------------------------------"
done

# Mostra resumo
echo "🏁 Processamento concluído!"
echo "📊 Resumo:"
echo "   - Total de arquivos: $TOTAL_FILES"
echo "   - Convertidos com sucesso: $SUCCESS"
echo "   - Falhas: $FAILED"

if [ $SUCCESS -gt 0 ]; then
  echo "📂 Os arquivos PNG estão disponíveis em: $OUTPUT_DIR"
fi

exit 0
