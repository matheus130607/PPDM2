# Requisitos

Referência principal: Avaliacao_Tutorial_Flutter_Firebase_Mapa.pdf, SENAI, 18 páginas, lido integralmente; primeira página renderizada e inspecionada. Seções 6/7: requisitos; 8: avaliação; 22–24: telas; 26: T01–T11; 28: extensões.

## Problema e objetivo

Permitir a consulta e manutenção de estabelecimentos em diferentes cidades com persistência no Firestore, em vez de uma lista fixa em código.

| Código | Comportamento |
|---|---|
| RF01 | Cidade selecionada e pelo menos São Paulo, Campinas, Jundiaí |
| RF02 | Pesquisa por nome ou categoria, sem diferenciar caixa e acentos |
| RF03 | Leitura por stream da coleção `locais` |
| RF04 | Filtros combinados por cidade, categoria, pesquisa e favoritos |
| RF05 | Cadastro validado em modal, evitando acionamentos repetidos |
| RF06 | Edição com mesmo ID |
| RF07 | Exclusão somente após confirmação |
| RF08 | Detalhes com todos os campos, placeholder e retorno |
| RF09 | Alteração de `favorito` no documento |
| RF10 | Mapa, resultados, detalhes, retorno e destaque no esquema |

## Requisitos adicionais do pedido

Mapa ilustrativo claramente identificado; marcadores representam somente documentos recebidos. Cinco marcadores aparecem quando os filtros retornarem pelo menos cinco documentos; a carga opcional prepara cinco locais em São Paulo, sem fabricar marcadores quando o banco estiver vazio. A lista é atualizada por snapshots. Formulário valida nome, categoria, cidade, avaliação finita 0–5 e distância finita não negativa; descrição e horário são opcionais e tratados em detalhes. Mensagens de carregamento, erro e ausência de dados. Interface responsiva, fundo claro e cards arredondados.

## Não funcionais

Flutter/Dart, Firebase/Firestore, configuração oficial FlutterFire, Android, separação de pastas e responsabilidades, sem banco remoto aberto, confirmação de exclusão, feedback de operações, documentação e testes reais. Não alterar outros projetos ou configurações globais; não gravar exemplos remotamente sem aprovação.

## Wireframe

Preservados: cabeçalho com cidade e pesquisa, representação do mapa, resultados em cards com filtros de categoria, imagem/placeholder em detalhes, nome/categoria/avaliação/distância/horário/descrição e botão Ver no mapa, navegação inferior. Favoritos é um filtro de resultados, sem quarta tela. Recursos visuais de ligação, agendamento, compartilhamento e GPS não receberam botões sem funcionalidade; não são obrigatórios nas seções 22–24.
