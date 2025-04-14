#!/bin/bash

# batch-convert.sh - Script para converter múltiplos arquivos PlantUML de uma vez
# Autor: Tiago N. Pinto Silva
# Versão: 1.1.0

# ===========================
# Configurações
# ===========================
# Pasta onde os arquivos serão salvos (padrão: ./output)
OUTPUT_DIR="${1:-./output}"
# Pasta com os arquivos de origem (padrão: ./examples)
INPUT_DIR="${2:-./examples}"
# Flag de verbosidade
VERBOSE=0
# Formato de saída (padrão: png)
OUTPUT_FORMAT="png"
# Caminho personalizado para o JAR do PlantUML (padrão: usar o do script principal)
PLANTUML_JAR_PATH=""
# Extensões de arquivo a processar
FILE_EXTENSIONS=("wsd" "puml" "plantuml" "iuml" "pu")

# ===========================
# Funções
# ===========================

# Função para exibir mensagem de ajuda
show_help() {
  echo "Uso: $(basename $0) [OPÇÕES] [DIRETÓRIO_SAÍDA] [DIRETÓRIO_ENTRADA]"
  echo
  echo "Converte todos os arquivos de diagrama PlantUML do diretório de entrada para o formato especificado"
  echo
  echo "Parâmetros posicionais (opcionais):"
  echo "  DIRETÓRIO_SAÍDA    Diretório onde os arquivos serão salvos (padrão: ./output)"
  echo "  DIRETÓRIO_ENTRADA  Diretório de onde os arquivos serão lidos (padrão: ./examples)"
  echo
  echo "Opções:"
  echo "  -h, --help              Exibe esta mensagem de ajuda"
  echo "  -v, --verbose           Exibe informações detalhadas durante o processamento"
  echo "  -f, --format FORMAT     Define o formato de saída (png, svg, eps, pdf) [padrão: png]"
  echo "  -j, --jar-path PATH     Define um caminho personalizado para o arquivo PlantUML JAR"
  echo "  -e, --extension EXT     Especifica extensão adicional para processar (pode ser usado múltiplas vezes)"
  echo "                          Extensões padrão: ${FILE_EXTENSIONS[*]}"
  echo
  echo "Exemplos:"
  echo "  $(basename $0)                        # Usa ./examples como entrada e ./output como saída"
  echo "  $(basename $0) ./diagramas            # Usa ./examples como entrada e ./diagramas como saída"
  echo "  $(basename $0) ./diagramas ./src      # Usa ./src como entrada e ./diagramas como saída"
  echo "  $(basename $0) -f svg ./diagramas     # Gera arquivos SVG em vez de PNG"
  echo "  $(basename $0) --verbose -f pdf       # Modo verbose com saída em PDF"
  echo
  exit 0
}

# ===========================
# Processamento de argumentos
# ===========================

# Array para armazenar argumentos não processados
NON_OPTION_ARGS=()

# Processa todos os argumentos da linha de comando
while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      show_help
      ;;
    -v|--verbose)
      VERBOSE=1
      shift
      ;;
    -f|--format)
      if [[ -n "$2" && "$2" != -* ]]; then
        case "$2" in
          png|svg|eps|pdf)
            OUTPUT_FORMAT="$2"
            shift 2
            ;;
          *)
            echo "❌ Erro: Formato de saída inválido: $2. Formatos suportados: png, svg, eps, pdf"
            exit 1
            ;;
        esac
      else
        echo "❌ Erro: Argumento ausente para a opção $1"
        exit 1
      fi
      ;;
    -j|--jar-path)
      if [[ -n "$2" && "$2" != -* ]]; then
        PLANTUML_JAR_PATH="$2"
        shift 2
      else
        echo "❌ Erro: Argumento ausente para a opção $1"
        exit 1
      fi
      ;;
    -e|--extension)
      if [[ -n "$2" && "$2" != -* ]]; then
        FILE_EXTENSIONS+=("$2")
        shift 2
      else
        echo "❌ Erro: Argumento ausente para a opção $1"
        exit 1
      fi
      ;;
    *)
      NON_OPTION_ARGS+=("$1")
      shift
      ;;
  esac
done

# Restaura os argumentos posicionais se fornecidos
if [[ ${#NON_OPTION_ARGS[@]} -ge 1 ]]; then
  OUTPUT_DIR="${NON_OPTION_ARGS[0]}"
fi
if [[ ${#NON_OPTION_ARGS[@]} -ge 2 ]]; then
  INPUT_DIR="${NON_OPTION_ARGS[1]}"
fi

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

# Constrói o padrão de extensões para usar com find
EXTENSION_PATTERN=$(IFS="|"; echo "${FILE_EXTENSIONS[*]}")

# Encontra todos os arquivos de diagrama no diretório de entrada
DIAGRAM_FILES=$(find "$INPUT_DIR" -type f -regextype posix-extended -regex ".*\.($EXTENSION_PATTERN)$")

# Verifica se encontrou arquivos
if [ -z "$DIAGRAM_FILES" ]; then
  echo "⚠️ Aviso: Nenhum arquivo de diagrama encontrado no diretório '$INPUT_DIR'."
  echo "   Extensões pesquisadas: ${FILE_EXTENSIONS[*]}"
  exit 0
fi

# Contador de arquivos
TOTAL_FILES=$(echo "$DIAGRAM_FILES" | wc -l)
CURRENT=0
SUCCESS=0
FAILED=0

echo "📋 Encontrados $TOTAL_FILES arquivos para conversão"
echo "📁 Diretório de saída: $OUTPUT_DIR"
echo "🖼️ Formato de saída: $OUTPUT_FORMAT"
echo "🚀 Iniciando processamento..."

# Prepara as opções para o script plantuml2png.sh
SCRIPT_OPTS="--output-dir \"$OUTPUT_DIR\" --format $OUTPUT_FORMAT"

if [ $VERBOSE -eq 1 ]; then
  SCRIPT_OPTS="$SCRIPT_OPTS --verbose"
fi

if [ -n "$PLANTUML_JAR_PATH" ]; then
  SCRIPT_OPTS="$SCRIPT_OPTS --jar-path \"$PLANTUML_JAR_PATH\""
fi

# Processa cada arquivo
for diagram_file in $DIAGRAM_FILES; do
  CURRENT=$((CURRENT + 1))
  FILENAME=$(basename "$diagram_file")
  
  echo "[$CURRENT/$TOTAL_FILES] Processando $FILENAME..."
  
  # Executa a conversão
  eval "$PLANTUML_SCRIPT $SCRIPT_OPTS \"$diagram_file\""
  
  # Verifica o resultado
  if [ $? -eq 0 ]; then
    SUCCESS=$((SUCCESS + 1))
    echo "✅ [$CURRENT/$TOTAL_FILES] $FILENAME convertido com sucesso"
  else
    FAILED=$((FAILED + 1))
    echo "❌ [$CURRENT/$TOTAL_FILES] Falha ao converter $FILENAME"
  fi
  
  echo "----------------------------------------"
done

# Mostra resumo
echo "🎯 Processamento concluído!"
echo "📊 Resumo:"
echo "   - Total de arquivos: $TOTAL_FILES"
echo "   - Convertidos com sucesso: $SUCCESS"
echo "   - Falhas: $FAILED"

if [ $SUCCESS -gt 0 ]; then
  echo "📂 Os arquivos $OUTPUT_FORMAT estão disponíveis em: $OUTPUT_DIR"
fi

exit 0
