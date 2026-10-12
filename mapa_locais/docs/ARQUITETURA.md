# Arquitetura

`main.dart`: inicialização, tratamento do bloqueio de configuração e injeção do repositório.
`firebase_bootstrap.dart`: ponto de integração substituído pelo script somente após FlutterFire gerar opções reais.
`app.dart`: tema Material 3, estado compartilhado de cidade/pesquisa/categoria/favoritos, assinatura única do stream, três telas e navegação.
`models/local.dart`: entidade imutável, ID externo e serialização dos oito campos; tolera números int/double/String com vírgula, valores ausentes ou inválidos. Limita avaliação a 0–5 e distância não negativa na leitura.
`services/local_service.dart`: interface `LocalRepository` e implementação `LocalService` com Firestore; snapshots, add, update, delete, favorito parcial. Sem dados fixos.
`screens`: mapa esquemático, resultados e detalhes. Detalhes são atualizados pelo mesmo stream, inclusive se o documento for excluído remotamente.
`widgets`: card, formulário modal e autenticação modal para conta autorizada.
`dialogs`: confirmação de exclusão.
`utils`: filtros e mensagens de erro sem expor dados de credenciais.
`test`: dados de teste isolados, repositório substituto e testes unitários/widgets.
`integration_test`: teste de leitura real, condicionado à configuração e sessão autenticada.

## Coleção

`locais/{id}` possui nome/categoria/cidade/horario/descricao String; avaliacao/distancia Number; favorito Boolean. Favoritos são compartilhados por documento conforme a versão básica do PDF. Não são favoritos individuais.

## Operações

Cadastro usa `add`; edição usa `update` no ID existente; exclusão usa `delete` após confirmação; favoritos usam `update` somente de `favorito`. O stream mantém UI e detalhes sincronizados. Operações em andamento desabilitam ações para o mesmo ID. Formulário bloqueia salvamento repetido e fechamento durante gravação.

## Limites

Filtragem em memória lê todos os locais acessíveis, adequada para a atividade inicial. A escala futura exige consultas/índices. O mapa não possui latitude/longitude, GPS ou cálculo de distância. Posicionamento esquemático é calculado apenas para distribuir documentos na imagem. Integração Firebase não pode ser validada sem projeto real. Regras propostas aguardam revisão e teste remoto, não foram implantadas.
