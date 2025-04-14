# PlantUML 2 PNG

![PlantUML](https://img.shields.io/badge/PlantUML-Converter-brightgreen)
![Bash](https://img.shields.io/badge/Language-Bash-blue)
![License](https://img.shields.io/badge/License-MIT-green)

**PlantUML 2 PNG** é uma ferramenta de linha de comando para gerar arquivos PNG de alta qualidade a partir de diagramas PlantUML (.wsd).

<p align="center">
  <img src="https://plantuml.com/img/plantuml-logo.png" alt="PlantUML Logo" width="200"/>
</p>

## 📋 Descrição

Este projeto fornece um conjunto de scripts robustos e fáceis de usar para automatizar a conversão de diagramas PlantUML em imagens PNG. É especialmente útil para:

- Desenvolvedores que documentam arquitetura e código com PlantUML
- Equipes de engenharia que mantêm diagramas como código
- Pipelines de CI/CD que precisam gerar documentação visual automaticamente
- Projetos que seguem metodologias de Documentação como Código (Documentation as Code)

## ✨ Características

- **Conversão Simples**: Transforme diagramas PlantUML (.wsd) em arquivos PNG com um único comando
- **Processamento em Lote**: Converta múltiplos diagramas de uma só vez
- **Configuração Automática**: Download automático do PlantUML JAR se não estiver presente
- **Personalizável**: Especifique diretórios de entrada e saída personalizados
- **Verbosidade Ajustável**: Opções para execução silenciosa ou detalhada
- **Portabilidade**: Funciona em qualquer sistema com Bash e Java instalados

## 🚀 Início Rápido

### Pré-requisitos

- [Java Runtime Environment (JRE)](https://www.java.com/pt-BR/download/) 8 ou superior
- Bash (disponível por padrão em sistemas Linux e macOS, ou via [Git Bash](https://gitforwindows.org/) no Windows)

### Instalação

1. Clone o repositório:
   ```bash
   git clone https://github.com/tiagonpsilva/plantuml_2_png.git
   cd plantuml_2_png
   ```

2. Torne os scripts executáveis:
   ```bash
   chmod +x plantuml2png.sh batch-convert.sh
   ```

### Uso Básico

#### Converter um único diagrama:
```bash
./plantuml2png.sh caminho/para/seu-diagrama.wsd
```

#### Converter com diretório de saída personalizado:
```bash
./plantuml2png.sh -o diretorio/saida caminho/para/seu-diagrama.wsd
```

#### Modo detalhado:
```bash
./plantuml2png.sh -v caminho/para/seu-diagrama.wsd
```

### Processamento em Lote

Para converter múltiplos diagramas de uma vez:

```bash
./batch-convert.sh diretorio/saida diretorio/com/diagramas
```

## 📂 Estrutura do Projeto

```
plantuml_2_png/
├── plantuml2png.sh        # Script principal para converter um único diagrama
├── batch-convert.sh       # Script para processamento em lote
├── examples/              # Diagramas de exemplo para teste
│   ├── class-diagram.wsd  # Exemplo de diagrama de classes
│   ├── sequence-diagram.wsd # Exemplo de diagrama de sequência
│   └── component-diagram.wsd # Exemplo de diagrama de componentes
└── README.md              # Este arquivo
```

## 🎯 Exemplos de Uso

### Exemplo 1: Conversão Básica

Converter um diagrama simples:

```bash
./plantuml2png.sh examples/class-diagram.wsd
```

Resultado:
- Um arquivo `class-diagram.png` será criado no mesmo diretório do arquivo original.

### Exemplo 2: Conversão com Diretório de Saída

```bash
./plantuml2png.sh -o ./output examples/sequence-diagram.wsd
```

Resultado:
- Um arquivo `sequence-diagram.png` será criado no diretório `./output/`.

### Exemplo 3: Processamento em Lote

Converter todos os diagramas em um diretório:

```bash
./batch-convert.sh ./output ./examples
```

Resultado:
- Todos os arquivos .wsd do diretório `./examples` serão convertidos para PNG e salvos em `./output/`.

## 🛠️ Parâmetros

### plantuml2png.sh

```
Uso: plantuml2png.sh [OPÇÕES] <arquivo-wsd>

Opções:
  -h, --help             Exibe mensagem de ajuda
  -v, --verbose          Modo detalhado
  -V, --version          Exibe a versão do script
  -o, --output-dir DIR   Define diretório de saída
```

### batch-convert.sh

```
Uso: batch-convert.sh [DIRETÓRIO_SAÍDA] [DIRETÓRIO_ENTRADA] [--verbose]

Parâmetros:
  DIRETÓRIO_SAÍDA   Diretório onde os PNGs serão salvos (padrão: ./output)
  DIRETÓRIO_ENTRADA Diretório de onde os .wsd serão lidos (padrão: ./examples)
  --verbose         Exibe informações detalhadas
```

## 📝 Notas de Implementação

- O script baixa automaticamente o arquivo `plantuml.jar` para `~/plantuml.jar` se não estiver presente.
- Utiliza diretórios temporários para processamento seguro, que são limpos após a conversão.
- Em caso de erro, fornece mensagens de diagnóstico para ajudar na resolução.

## 🔄 Integração com Fluxos de Trabalho

### GitHub Actions

Exemplo de uso em um fluxo de trabalho GitHub Actions:

```yaml
name: Generate Diagrams

on:
  push:
    paths:
      - '**.wsd'
      - '**.puml'

jobs:
  convert:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Set up JDK
        uses: actions/setup-java@v2
        with:
          java-version: '11'
          distribution: 'adopt'
      - name: Generate PNGs
        run: |
          chmod +x ./plantuml_2_png/batch-convert.sh
          ./plantuml_2_png/batch-convert.sh ./docs/images ./docs/diagrams
      - name: Commit changes
        uses: EndBug/add-and-commit@v7
        with:
          author_name: GitHub Actions
          author_email: actions@github.com
          message: 'docs: update diagram images'
          add: 'docs/images/*.png'
```

### Makefile

Exemplo de integração em um Makefile:

```make
.PHONY: diagrams docs

diagrams:
	@echo "Generating diagram images..."
	./plantuml_2_png/batch-convert.sh ./docs/images ./docs/diagrams

docs: diagrams
	@echo "Building documentation..."
	# Comandos adicionais para construir documentação
```

## 🤝 Contribuindo

Contribuições são bem-vindas! Se você quiser melhorar este projeto:

1. Faça um fork do repositório
2. Crie uma branch para sua feature (`git checkout -b feature/nova-funcionalidade`)
3. Faça commit das suas mudanças (`git commit -m 'feat: adiciona nova funcionalidade'`)
4. Faça push para a branch (`git push origin feature/nova-funcionalidade`)
5. Abra um Pull Request

## 📚 Recursos Adicionais

- [Documentação oficial do PlantUML](https://plantuml.com/)
- [Referência de sintaxe do PlantUML](https://plantuml.com/guide)
- [Exemplos de diagramas PlantUML](https://real-world-plantuml.com/)

## 📄 Licença

Este projeto está licenciado sob a MIT License - veja o arquivo [LICENSE](LICENSE) para detalhes.

## 👤 Autor

- **Tiago N. Pinto Silva** - [GitHub](https://github.com/tiagonpsilva)

---

⭐️ Se este projeto foi útil para você, considere dar uma estrela no GitHub! ⭐️
