# Progresso

Sessão iniciada em 11/10/2026 (São Paulo). Diretório inicial do Codex: `C:\Users\mathe\Documents\Codex\2026-10-11\files-pasted-by-the-user-projeto`. Projeto inicialmente criado em `outputs/mapa_locais`; após orientação do usuário, pasta principal passou a `C:\Users\mathe\OneDrive\Área de Trabalho\mapa_locais`. Cópia inicial preservada, sem remover arquivos. Nenhum trabalho MALAMAN/SENTINEL alterado.

## Etapa 1 — diagnóstico e preparação

- Diretório inicial vazio, somente work/outputs, sem Git. Busca encontrou apenas projeto flutter-check de outra sessão, não relacionado; não modificado.
- PDF localizado em Downloads após resposta do usuário; 18 páginas extraídas e lidas, primeira página renderizada/inspecionada.
- Flutter stable 3.47.6, Dart 3.13.5, Android SDK 36.0.0, Java 25.0.3, Node 24.20.0, npm 11.19.0, Git 2.56.0. Android Studio instalado. Doctor passou; licenças aceitas.
- `flutter devices`: Windows/Chrome/Edge. `flutter emulators`: erro, fontes de emulador indisponíveis. AVD Medium Phone cadastrado, mas SDK sem emulator/system-images disponíveis.
- Criado `mapa_locais` com plataforma Android e applicationId `br.edu.mapa.mapa_locais`.
- Ação do usuário: permitir configuração do emulador ou conectar Android; preferencialmente celular com depuração USB.

## Etapa 2 — Firebase

- Adicionadas firebase_core/cloud_firestore/firebase_auth; pub get passou. Model Local robusto e serviço real de snapshots/CRUD/favoritos.
- Firebase CLI 15.33.0 e FlutterFire CLI 1.4.1 instalados localmente em .tooling sem PATH global. login:list sem conta.
- Arquivos: lib/models/local.dart, services/local_service.dart, firebase_bootstrap.dart, scripts/configure_firebase.ps1, firestore.rules, firestore.proposed.rules, firebase.json.
- Bootstrap sem credenciais fabricadas; inicialização real será escrita pelo script após geração oficial de firebase_options.dart.
- Sem leitura remota por ausência de projeto/autenticação. Regras baseline negam tudo; proposta de usuários autorizados aguardando aprovação. Login modal preparado sem criar contas.
- Rotina seed administrativa opcional, transacional e idempotente; dez registros de exemplo em data. Sintaxe Node validada e execução sem aprovação bloqueada. Não houve carga remota.
- Ação do usuário: Project ID, login Google, criação/habilitação do banco se necessário e aprovação de política remota/carga.

## Etapa 3 — CRUD e resultados

- Lista por stream, pesquisa, cidades, categorias descobertas nos dados, favoritos, cadastro/edição modal, confirmação de exclusão, botões desabilitados durante operação e feedback.
- Arquivos: resultados_screen.dart, local_card.dart, local_form.dart, confirm_delete.dart, utils/filters.dart e feedback.dart.
- Validações: textos obrigatórios, números finitos, avaliação 0–5, distância não negativa, vírgula decimal, limites de texto; horário/descrição tratados como opcionais.
- Testes locais passaram para cadastro, edição, exclusão, favoritos e erros. Persistência remota pendente.

## Etapa 4 — mapa e detalhes

- Mapa customizado esquemático, sem alegar GPS/coordenadas reais; marcadores apenas dos documentos recebidos. Ver resultados e destaque no mapa.
- Detalhes com todos os campos, placeholder, favorito por stream e retorno. Se documento desaparecer, exibe mensagem apropriada.
- app.dart coordena três telas e filtros compartilhados. Favoritos usa resultados, sem quarta tela.
- Arquivos: mapa_screen.dart, detalhes_screen.dart, app.dart e main.dart. Testes de navegação passaram.

## Etapa 5 — qualidade

- Material 3, azul-petróleo, fundo claro, cards arredondados, largura máxima 720 e conteúdo rolável.
- AndroidManifest inclui INTERNET e nome amigável. Separação de repositório/UI/modelo e mensagens de erro compreensíveis.
- dart format executado; flutter analyze sem erros na verificação realizada.
- Primeira bateria: um teste falhou por interação durante SnackBar. Sincronização corrigida para dispensar mensagens antes de tocar em Ver no mapa; segunda bateria: dez testes passaram.
- Pré-visualizações de widgets em resolução de celular preparadas, sempre com banner DADOS SIMULADOS; não equivalem à execução Android.

## Etapa 6 — testes e entrega

- Flutter pub get/analyze/test executados. APK debug em compilação no caminho original; resultado será atualizado.
- O Gradle baixou automaticamente Android Platform 34 para dependências do build. Avisos: plugins Firebase ainda aplicam KGP; ferramentas SDK com versões XML diferentes. Não houve atualização global de Flutter/Java/PATH.
- Documentação obrigatória, checklist com os pesos exatos de 100 pontos e plano de extensões criados. Capturas finais reservadas.
- Integração somente de leitura preparada em integration_test/firestore_connection_test.dart; não executada sem backend/sessão.
- Ações restantes: autenticação/projeto Firebase, aprovação/revisão das regras, dez registros remotos, execução Android e T01–T11 remotos.

## Próxima etapa

Concluir build e validação da pasta na Área de Trabalho; então configurar o projeto Firebase real com participação do usuário. Não declarar integração completa antes da leitura e CRUD remotos.

## Atualização após transferência

- Código principal agora na Área de Trabalho conforme instrução do usuário. CLIs locais reutilizadas por `.tooling_path.txt`, sem reinstalação nem cópia de caches pesados para OneDrive.
- Onze testes passaram na pasta final, depois dos ajustes de prévias. Dart analyze passou diretamente. Flutter analyze teve falha de framing LSP com Unicode; passou através de junction local sem acentos, apontando para a mesma pasta.
- APK inicial gerado com sucesso em 376,3 s e preservado em apk/. Compilação final em andamento após ajuste de texto de avaliação e gradle.properties local.
- Prévias de widgets renderizadas/inspecionadas: fontes de teste inicialmente Ahem; carregadas fontes legíveis e MaterialIcons. Banner explícito de dados simulados. Ajustada restauração de debug de sombras após falha do teste, com nova execução aprovada.
- Usuário informou que ainda não tem projeto Firebase e autorizou componentes de emulador. Firebase Console aberto para participação; instalação de emulator e imagem API 36 no SDK existente iniciada. AVD anterior preservado. WHPX disponível.

## Estado atual de execução

- Segunda compilação final da pasta da Área de Trabalho passou em 80,5 s. APK atualizado em apk/mapa_locais-debug.apk.
- Emulator 37.2.12.0 e imagem API 36 Google APIs x86_64 instalados com autorização. Criado Mapa_Locais_API_36; AVD anterior preservado.
- Tentativa real de boot com WHPX falhou por memória comprometida livre insuficiente (877 MB, necessários 2560 MB). Usuário solicitado a liberar memória; não foram encerrados processos de outros programas nem alterada a memória virtual.
- Usuário autorizou criação de projeto Firebase com nome Mapa de Locais, sem faturamento/Analytics. Google exibiu a conta solicitada e pediu senha. Login entregue ao usuário no navegador; senha/códigos não solicitados pelo chat. Projeto ainda não criado, aguardando login.
- T01–T11 remotos continuam pendentes. Rotina de carga inicial e regras remotas não executadas nem aprovadas. Nova aprovação será necessária para carga e publicação das regras propostas.

- Repositório Git local inicializado na pasta nova, sem commit, sem remote e sem alterar repositórios existentes. Todos os arquivos novos permanecem disponíveis para revisão; ferramentas/caches e o ponteiro local são ignorados.
- Acrescentada validação explícita do seletor de cidade ao editar documentos malformados. Teste T05 direcionado passou; recompilação incremental passou em 27,8 s. Código atualizado no APK de apk/.

- Usuário relatou dificuldade de login; verificado Console integrado com mensagem de sessão encerrada, sem evidência de senha incorreta. Firebase CLI oficial login executado e fluxo de autorização local identificado. Ainda sem contas autorizadas. Criado script login_firebase.ps1 com código digitado ocultamente no terminal local; não pedir senha/códigos no chat. Sintaxe dos scripts PowerShell validada.
- Último APK: 173.847.941 bytes; SHA256 C1A25B40DB3B90E9CFF0653FBC1B24D671C1836BF84142803889E5B5AC4A1231. Dart analyze final passou. A validação de requisitos remotos permanece pendente.
