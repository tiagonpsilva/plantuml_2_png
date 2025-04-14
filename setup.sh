#!/bin/bash

# setup.sh - Script para facilitar a configuração inicial do PlantUML 2 PNG
# Autor: Tiago N. Pinto Silva

echo "🚀 Iniciando configuração do PlantUML 2 PNG..."

# Verifica se o Java está instalado
if command -v java &> /dev/null; then
    JAVA_VERSION=$(java -version 2>&1 | head -1 | cut -d'"' -f2 | sed 's/^1\.//' | cut -d'.' -f1)
    echo "✅ Java encontrado (versão $JAVA_VERSION)"
else
    echo "❌ Java não encontrado. Por favor, instale o Java (JRE 8 ou superior)"
    echo "   Visite: https://www.java.com/download/"
    exit 1
fi

# Tornar os scripts executáveis
echo "📜 Tornando os scripts executáveis..."
chmod +x plantuml2png.sh batch-convert.sh

# Criar diretório de output se não existir
if [ ! -d "output" ]; then
    echo "📁 Criando diretório de saída (output)..."
    mkdir -p output
fi

# Verificar se o PlantUML JAR já existe
PLANTUML_JAR_PATH="$HOME/plantuml.jar"
if [ -f "$PLANTUML_JAR_PATH" ]; then
    echo "✅ PlantUML JAR já existe em $PLANTUML_JAR_PATH"
else
    echo "🔄 PlantUML JAR não encontrado. O script irá baixá-lo automaticamente na primeira execução."
fi

# Testar conversão de exemplo
echo "🧪 Deseja testar a conversão com um exemplo? (S/n)"
read -r response
if [[ "$response" =~ ^([sS]|[sS][iI][mM]|"")$ ]]; then
    # Selecionar um exemplo aleatório
    RANDOM_EXAMPLE=$(find examples -name "*.wsd" | shuf -n 1)
    if [ -n "$RANDOM_EXAMPLE" ]; then
        echo "🔍 Testando com o exemplo: $RANDOM_EXAMPLE"
        ./plantuml2png.sh -v "$RANDOM_EXAMPLE"
        
        # Verificar se a conversão foi bem-sucedida
        BASE_NAME=$(basename "$RANDOM_EXAMPLE" .wsd)
        if [ -f "$(dirname "$RANDOM_EXAMPLE")/$BASE_NAME.png" ]; then
            echo "🎉 Teste concluído com sucesso! Verifique a imagem gerada em $(dirname "$RANDOM_EXAMPLE")/$BASE_NAME.png"
        fi
    else
        echo "⚠️ Nenhum exemplo encontrado no diretório 'examples'"
    fi
fi

echo "✨ Configuração concluída! Agora você pode usar o PlantUML 2 PNG para converter seus diagramas."
echo
echo "📖 Uso básico:"
echo "  ./plantuml2png.sh seu-diagrama.wsd        # Converter um arquivo"
echo "  ./batch-convert.sh                         # Converter todos os arquivos de examples/ para output/"
echo
echo "📘 Para mais informações, consulte o README.md"

exit 0
