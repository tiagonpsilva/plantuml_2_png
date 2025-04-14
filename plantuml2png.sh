#!/bin/bash

# plantuml2png.sh - Ferramenta para gerar PNG a partir de diagramas PlantUML
# Autor: Tiago N. Pinto Silva
# Versão: 1.1.0

# ===========================
# Configurações
# ===========================
VERSION="1.1.0"
SCRIPT_NAME=$(basename "$0")
PLANTUML_JAR_PATH="$HOME/plantuml.jar"
PLANTUML_DOWNLOAD_URL="https://sourceforge.net/projects/plantuml/files/plantuml.jar/download"
VERBOSE=0
OUTPUT_DIR=""
CONFIG_FILE="$HOME/.plantuml2png.conf"
OUTPUT_FORMAT="png"

# ===========================
# Funções
# ===========================

# Exibe a versão do script
show_version() {
  echo "$SCRIPT_NAME versão $VERSION"
  exit 0
}

# Exibe a mensagem de ajuda
show_help() {
  echo "Uso: $SCRIPT_NAME [OPÇÕES] <arquivo-wsd>"
  echo
  echo "Utilitário para gerar arquivos PNG a partir de diagramas PlantUML (.wsd)"
  echo
  echo "Opções:"
  echo "  -h, --help              Exibe esta mensagem de ajuda"
  echo "  -v, --verbose           Modo detalhado, exibe mais informações durante a execução"
  echo "  -V, --version           Exibe a versão do script"
  echo "  -o, --output-dir DIR    Define o diretório de saída para os arquivos PNG gerados"
  echo "  -j, --jar-path PATH     Define um caminho personalizado para o arquivo PlantUML JAR"
  echo "  -f, --format FORMAT     Define o formato de saída (png, svg, eps, pdf) [padrão: png]"
  echo "  -c, --config FILE       Usa um arquivo de configuração personalizado"
  echo
  echo "Exemplos:"
  echo "  $SCRIPT_NAME diagrama.wsd                    # Gera diagrama.png no mesmo diretório"
  echo "  $SCRIPT_NAME -o imagens/ diagrama.wsd        # Gera imagens/diagrama.png"
  echo "  $SCRIPT_NAME -v -o ~/imagens/ diagrama.wsd   # Modo detalhado com diretório de saída personalizado"
  echo "  $SCRIPT_NAME -f svg diagrama.wsd             # Gera diagrama.svg no mesmo diretório"
  echo
  exit 0
}

# Exibe mensagem de log
log() {
  local level=$1
  local message=$2
  
  if [[ "$level" == "ERROR" ]] || [[ "$level" == "SUCCESS" ]] || [[ $VERBOSE -eq 1 ]]; then
    case "$level" in
      "INFO")    echo "[INFO] $message" ;;
      "WARNING") echo "[AVISO] $message" ;;
      "ERROR")   echo "❌ [ERRO] $message" >&2 ;;
      "SUCCESS") echo "✅ [SUCESSO] $message" ;;
      *)         echo "$message" ;;
    esac
  fi
}

# Carregar configurações do arquivo (se existir)
load_config() {
  local config_file="${1:-$CONFIG_FILE}"
  
  if [ -f "$config_file" ]; then
    log "INFO" "Carregando configurações de $config_file"
    # shellcheck source=/dev/null
    source "$config_file"
    return 0
  fi
  
  return 1
}

# Verifica se o PlantUML JAR existe ou baixa
check_plantuml_jar() {
  if [ ! -f "$PLANTUML_JAR_PATH" ]; then
    log "INFO" "PlantUML JAR não encontrado em $PLANTUML_JAR_PATH. Baixando..."
    
    # Verifica se curl está instalado
    if ! command -v curl &> /dev/null; then
      log "ERROR" "curl não está instalado. Por favor, instale curl para baixar o PlantUML JAR."
      exit 1
    fi
    
    curl -L "$PLANTUML_DOWNLOAD_URL" -o "$PLANTUML_JAR_PATH"
    
    if [ $? -ne 0 ]; then
      log "ERROR" "Falha ao baixar o PlantUML JAR."
      exit 1
    fi
    
    log "SUCCESS" "PlantUML JAR baixado com sucesso para $PLANTUML_JAR_PATH"
  else
    log "INFO" "PlantUML JAR encontrado em $PLANTUML_JAR_PATH"
  fi
}

# Verifica se Java está instalado
check_java() {
  if ! command -v java &> /dev/null; then
    log "ERROR" "Java não está instalado. Por favor, instale o Java Runtime Environment (JRE)."
    exit 1
  fi
  
  JAVA_VERSION=$(java -version 2>&1 | head -1 | cut -d'"' -f2)
  log "INFO" "Usando Java versão $JAVA_VERSION"
}

# Processa um arquivo PlantUML e gera o arquivo de saída no formato especificado
process_file() {
  local input_file=$1
  local output_format=${2:-$OUTPUT_FORMAT}
  
  # Verifica se o arquivo de entrada existe
  if [ ! -f "$input_file" ]; then
    log "ERROR" "Arquivo de entrada não existe: $input_file"
    exit 1
  fi
  
  # Obtém o nome do arquivo e diretório
  local filename=$(basename "$input_file")
  local base_filename="${filename%.*}"
  local input_dir=$(dirname "$input_file")
  
  # Define o diretório de saída (usa o diretório de entrada se não especificado)
  local output_dir=${OUTPUT_DIR:-$input_dir}
  
  # Obtém caminhos absolutos
  local abs_input_file=$(realpath "$input_file")
  local abs_input_dir=$(dirname "$abs_input_file")
  mkdir -p "$output_dir"
  local abs_output_dir=$(realpath "$output_dir")
  
  log "INFO" "Processando: $abs_input_file"
  log "INFO" "Diretório de saída: $abs_output_dir"
  log "INFO" "Formato de saída: $output_format"
  
  # Cria um diretório temporário
  local temp_dir=$(mktemp -d)
  log "INFO" "Usando diretório temporário: $temp_dir"
  
  # Copia o arquivo de entrada para o diretório temporário
  cp "$abs_input_file" "$temp_dir/"
  local temp_filename=$(basename "$abs_input_file")
  
  # Muda para o diretório temporário
  cd "$temp_dir" || exit 1
  
  # Executa o PlantUML
  log "INFO" "Executando PlantUML..."
  
  # Opções do PlantUML baseadas no formato desejado
  local plantuml_opts="-t$output_format"
  
  if [ $VERBOSE -eq 1 ]; then
    java -jar "$PLANTUML_JAR_PATH" -verbose $plantuml_opts "$temp_filename"
  else
    java -jar "$PLANTUML_JAR_PATH" $plantuml_opts "$temp_filename" >/dev/null 2>&1
  fi
  
  # Verifica se o comando Java retornou com sucesso
  if [ $? -ne 0 ]; then
    log "ERROR" "Erro ao executar o PlantUML. Verifique se o arquivo de diagrama é válido."
    # Limpa o diretório temporário
    rm -rf "$temp_dir"
    return 1
  fi
  
  # Verifica se algum arquivo de saída foi criado
  GENERATED_FILES=$(find . -name "*.$output_format" -type f)
  
  if [ -n "$GENERATED_FILES" ]; then
    log "INFO" "Arquivo(s) gerado(s) no diretório temporário:"
    
    if [ $VERBOSE -eq 1 ]; then
      ls -la *.$output_format
    fi
    
    # Obtém o primeiro arquivo gerado encontrado
    GENERATED_FILE=$(echo "$GENERATED_FILES" | head -1)
    log "INFO" "Arquivo gerado: $GENERATED_FILE"
    
    # Define o caminho do arquivo de saída
    OUTPUT_FILE="$abs_output_dir/${base_filename}.$output_format"
    
    # Copia o arquivo gerado para o diretório de saída
    cp "$GENERATED_FILE" "$OUTPUT_FILE"
    
    log "SUCCESS" "Conversão do diagrama PlantUML concluída com sucesso."
    log "INFO" "🖼️ Arquivo gerado: $OUTPUT_FILE"
    
    # Verifica se o nome do arquivo gerado é diferente do esperado (o que indica que o título no diagrama foi usado)
    if [ "$(basename "$GENERATED_FILE")" != "${base_filename}.$output_format" ]; then
      log "INFO" "🔍 Nota: O arquivo original foi nomeado \"$(basename "$GENERATED_FILE")\" baseado no título do diagrama"
    fi
    
    # Limpa o diretório temporário
    rm -rf "$temp_dir"
    return 0
  else
    log "ERROR" "Arquivo de saída não foi criado."
    log "INFO" "Arquivos no diretório temporário:"
    
    if [ $VERBOSE -eq 1 ]; then
      ls -la
    fi
    
    log "INFO" "Tente executar este comando manualmente:"
    log "INFO" "cd \"$abs_input_dir\" && java -jar $PLANTUML_JAR_PATH -t$output_format \"$filename\""
    
    # Limpa o diretório temporário
    rm -rf "$temp_dir"
    return 1
  fi
}

# ===========================
# Processamento de argumentos
# ===========================

# Verifica se não há argumentos
if [ $# -eq 0 ]; then
  show_help
fi

# Tenta carregar o arquivo de configuração padrão se existir
load_config

# Processamento de opções
while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      show_help
      ;;
    -v|--verbose)
      VERBOSE=1
      shift
      ;;
    -V|--version)
      show_version
      ;;
    -o|--output-dir)
      if [[ -n "$2" && "$2" != -* ]]; then
        OUTPUT_DIR="$2"
        shift 2
      else
        log "ERROR" "Argumento ausente para a opção $1"
        exit 1
      fi
      ;;
    -j|--jar-path)
      if [[ -n "$2" && "$2" != -* ]]; then
        PLANTUML_JAR_PATH="$2"
        shift 2
      else
        log "ERROR" "Argumento ausente para a opção $1"
        exit 1
      fi
      ;;
    -f|--format)
      if [[ -n "$2" && "$2" != -* ]]; then
        case "$2" in
          png|svg|eps|pdf)
            OUTPUT_FORMAT="$2"
            ;;
          *)
            log "ERROR" "Formato de saída inválido: $2. Formatos suportados: png, svg, eps, pdf"
            exit 1
            ;;
        esac
        shift 2
      else
        log "ERROR" "Argumento ausente para a opção $1"
        exit 1
      fi
      ;;
    -c|--config)
      if [[ -n "$2" && "$2" != -* ]]; then
        load_config "$2"
        shift 2
      else
        log "ERROR" "Argumento ausente para a opção $1"
        exit 1
      fi
      ;;
    -*)
      log "ERROR" "Opção desconhecida: $1"
      exit 1
      ;;
    *)
      # Assume que é o arquivo de entrada
      INPUT_FILE="$1"
      shift
      ;;
  esac
done

# Verifica se o arquivo de entrada foi fornecido
if [ -z "$INPUT_FILE" ]; then
  log "ERROR" "Nenhum arquivo de entrada especificado."
  exit 1
fi

# ===========================
# Execução principal
# ===========================

# Inicializando
if [ $VERBOSE -eq 1 ]; then
  log "INFO" "===== PlantUML PNG Generator v$VERSION ====="
fi

# Verifica se Java está instalado
check_java

# Verifica/baixa o PlantUML JAR
check_plantuml_jar

# Processa o arquivo
process_file "$INPUT_FILE" "$OUTPUT_FORMAT"
exit_code=$?

exit $exit_code
