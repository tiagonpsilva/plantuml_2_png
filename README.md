# PlantUML 2 PNG

Utilitário para gerar arquivos PNG a partir de diagramas PlantUML (.wsd)

## Descrição

Este utilitário permite converter arquivos de diagrama PlantUML (.wsd) em imagens PNG, facilitando a visualização e inclusão em documentos. 

Ele oferece:
- Conversão individual de diagramas
- Processamento em lote de múltiplos diagramas
- Download automático do JAR do PlantUML (se necessário)
- Configuração de diretório de saída personalizado

## Requisitos

- Java (JRE 8 ou superior)
- Bash (Linux, macOS, ou Windows com WSL/Git Bash)
- Acesso à internet (para o download automático do PlantUML JAR na primeira execução)

## Instalação

```bash
# Clone o repositório
git clone https://github.com/tiagonpsilva/plantuml_2_png.git

# Entre no diretório
cd plantuml_2_png

# Torne os scripts executáveis
chmod +x plantuml2png.sh batch-convert.sh
```

## Uso

### Conversão de um único arquivo

```bash
./plantuml2png.sh [OPÇÕES] <arquivo.wsd>
```

Opções:
- `-h, --help` - Exibe a mensagem de ajuda
- `-v, --verbose` - Modo detalhado, exibe mais informações durante a execução
- `-V, --version` - Exibe a versão do script
- `-o, --output-dir DIR` - Define o diretório de saída para os arquivos PNG gerados

Exemplos:
```bash
# Conversão simples
./plantuml2png.sh diagrama.wsd

# Conversão com diretório de saída personalizado
./plantuml2png.sh -o imagens/ diagrama.wsd

# Conversão em modo detalhado
./plantuml2png.sh -v diagrama.wsd
```

### Conversão em lote

```bash
./batch-convert.sh [DIRETÓRIO_SAÍDA] [DIRETÓRIO_ENTRADA] [--verbose]
```

Parâmetros:
- `DIRETÓRIO_SAÍDA` - Diretório onde os PNGs serão salvos (padrão: ./output)
- `DIRETÓRIO_ENTRADA` - Diretório onde os arquivos .wsd serão lidos (padrão: ./examples)
- `--verbose` - Exibe informações detalhadas durante o processamento

Exemplos:
```bash
# Usar configurações padrão
./batch-convert.sh

# Personalizar diretório de saída
./batch-convert.sh ./diagramas

# Personalizar diretórios de entrada e saída
./batch-convert.sh ./diagramas ./src
```

### Exemplo com URL do PlantUML

Você também pode converter diagramas a partir de uma URL do PlantUML:

1. Obtenha o código fonte do diagrama a partir da URL e salve-o em um arquivo `.wsd`
2. Execute o script `plantuml2png.sh` neste arquivo

Por exemplo, para converter o diagrama desta URL: `https://www.plantuml.com/plantuml/uml/SyfFKj2rKt3CoKnELR1Io4ZDoSa70000`

```bash
# Extraia o código do diagrama (um diagrama simples "Bob -> Alice : hello")
echo "@startuml
Bob -> Alice : hello
@enduml" > simple_diagram.wsd

# Converta para PNG
./plantuml2png.sh -v -o output/ simple_diagram.wsd
```

Para executar nosso exemplo, use o script `run_example.sh`:

```bash
# Torne o script executável
chmod +x run_example.sh

# Execute o exemplo
./run_example.sh
```

## Estrutura do Projeto

- `plantuml2png.sh` - Script principal para conversão de arquivos individuais
- `batch-convert.sh` - Script para processamento em lote
- `examples/` - Diretório com exemplos de diagramas PlantUML
- `output/` - Diretório padrão para armazenar os PNGs gerados (criado automaticamente)
- `run_example.sh` - Script de exemplo para demonstrar a conversão do diagrama "Hello World"

## Licença

Este projeto é distribuído sob a licença MIT.

## Autor

Tiago N. Pinto Silva
