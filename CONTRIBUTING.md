# Contribuindo para PlantUML 2 PNG

Primeiro de tudo, obrigado por dedicar seu tempo para contribuir! 🎉

As seguintes diretrizes ajudarão você a contribuir com este projeto. Use seu melhor julgamento e sinta-se à vontade para propor mudanças neste documento em um pull request.

## Código de Conduta

Este projeto e todos os participantes são regidos por um Código de Conduta. Ao participar, espera-se que você respeite este código. Por favor, reporte comportamento inaceitável.

## Como posso contribuir?

### Reportando Bugs

Esta seção orienta sobre como enviar um relatório de bug. Seguir estas diretrizes ajuda os mantenedores a entender seu relatório, reproduzir o comportamento e encontrar relatórios relacionados.

- Use o modelo de issue para bugs se disponível.
- Verifique se o bug já não foi reportado pesquisando nas Issues do GitHub.
- Use um título claro e descritivo para identificar o problema.
- Descreva os passos exatos para reproduzir o problema.
- Forneça exemplos específicos para demonstrar os passos.
- Descreva o comportamento que você observou após seguir os passos.
- Explique qual comportamento você esperava ver em vez disso e por quê.
- Inclua screenshots ou vídeos quando possível.
- Se o problema está relacionado a desempenho ou memória, inclua um perfil de CPU.
- Se o terminal mostra erros, inclua a saída do terminal.

### Sugerindo Melhorias

Esta seção orienta sobre como enviar uma sugestão de melhoria, desde pequenas melhorias até grandes novos recursos:

- Use o modelo de issue para solicitações de recursos se disponível.
- Use um título claro e descritivo.
- Forneça uma descrição passo a passo do aprimoramento sugerido com o máximo de detalhes possível.
- Inclua exemplos específicos para demonstrar os passos ou apontar partes relacionadas do código.
- Descreva o comportamento atual e explique qual comportamento você esperava ver em vez disso e por quê.
- Explique por que esse aprimoramento seria útil para a maioria dos usuários.
- Enumere alguns outros aplicativos ou projetos onde essa melhoria existe, se aplicável.

### Pull Requests

- Preencha o modelo de pull request se disponível.
- Não inclua números de issue no título do PR.
- Siga a convenção de codificação usada no projeto.
- Mantenha cada PR focado em uma única funcionalidade ou correção.
- Documente código novo e modificado.
- As mudanças devem ter testes.
- Atualize a documentação se necessário.
- Certifique-se de que os testes passam.

## Convenções de Estilo

### Mensagens de Commit

Usamos [Conventional Commits](https://www.conventionalcommits.org/) para as mensagens de commit:

- `feat`: Nova funcionalidade
- `fix`: Correção de bug
- `docs`: Mudanças na documentação
- `style`: Formatação, ponto e vírgula ausente etc.
- `refactor`: Refatoração de código
- `test`: Adição de testes
- `chore`: Tarefas de manutenção, atualização de dependências etc.

Exemplos:
```
feat: adiciona suporte para várias extensões de arquivo
fix: resolve problema de memória ao processar arquivos grandes
docs: atualiza instruções de instalação
```

### Scripts Shell

- Use as [diretrizes de estilo do Google para scripts Shell](https://google.github.io/styleguide/shellguide.html).
- Use `set -e` para garantir que o script falhe em caso de erro.
- Adicione comentários para explicar o que cada parte complexa do código faz.
- Verifique seu código com [ShellCheck](https://www.shellcheck.net/).

## Notas Adicionais

### Estrutura do Projeto

```
plantuml_2_png/
├── plantuml2png.sh        # Script principal
├── batch-convert.sh       # Script para processamento em lote
├── examples/              # Diagramas de exemplo
│   ├── class-diagram.wsd
│   ├── sequence-diagram.wsd
│   └── component-diagram.wsd
├── README.md              # Documentação principal
├── CONTRIBUTING.md        # Este arquivo
└── LICENSE                # Licença MIT
```

### Tags e Branches

- `main` contém a versão estável atual
- Branches de desenvolvimento devem seguir o padrão `feature/nome-da-feature` ou `bugfix/nome-da-correcao`

## Agradecimentos

Este guia foi inspirado por vários guias de contribuição de projetos de código aberto, incluindo [Atom](https://github.com/atom/atom/blob/master/CONTRIBUTING.md) e [Angular](https://github.com/angular/angular/blob/main/CONTRIBUTING.md).
