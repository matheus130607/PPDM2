# Testes — resultados reais

Data da sessão: iniciada em 11/10/2026, horário de São Paulo. Não houve execução Android ou conexão remota. Os testes locais usam um repositório substituto exclusivamente em `test/`.

## Comandos executados

- `flutter doctor -v`: passou, sem problemas relatados; licenças aceitas.
- `flutter --version`, `dart --version`: 3.47.6 / 3.13.5.
- `flutter devices`: somente Windows, Chrome e Edge; nenhum Android.
- `flutter emulators`: falhou, nenhuma fonte de emulador encontrada. Há AVD cadastrado, mas SDK sem pasta emulator/system-images disponível.
- `flutter pub get`: passou.
- `dart format lib test integration_test`: executado.
- `flutter analyze`: passou, sem problemas na execução anterior aos previews.
- `flutter test`: primeira execução 9 passaram/1 falhou por botão coberto por SnackBar no teste. Corrigida sincronização do teste; segunda execução: **10 passaram**.
- `flutter build apk --debug`: em andamento; atualizar resultado ao terminar.
- Firebase CLI 15.33.0 e FlutterFire CLI 1.4.1: disponíveis localmente; `firebase login:list` sem contas autenticadas.
- `node --check scripts/seed.cjs`: passou. Execução sem aprovação/projeto: bloqueada deliberadamente antes de qualquer acesso remoto; código de saída 1 esperado.

## Seção 26 do PDF

| ID | Procedimento obrigatório | Evidência local | Banco/dispositivo real |
|---|---|---|---|
| T01 | Abrir e verificar dados Firestore | Teste de integração preparado em integration_test | Não executado: projeto e sessão ausentes |
| T02 | Pesquisar Academia | Passou: filtro por categoria/nome, caixa e acentos | Pendente |
| T03 | Selecionar Campinas | Passou: filtro de cidade unitário | Pendente |
| T04 | Selecionar categoria | Passou: composição dos filtros | Pendente |
| T05 | Cadastrar e verificar no Firestore | Passou: validações, vírgula decimal, salvamento único em widgets | Pendente: escrita remota |
| T06 | Fechar/reabrir e verificar registro | Stream implementado; persistência remota não testada | Não executado |
| T07 | Editar nome/horário | Passou: formulário preenchido, alteração de nome e ID mantido | Pendente |
| T08 | Excluir e confirmar desaparecimento | Passou: cancelar preserva; confirmar remove da lista | Pendente |
| T09 | Marcar/desmarcar favorito | Passou: detalhes atualizados pelo stream de teste | Pendente |
| T10 | Resultados, detalhes e retorno | Passou: abrir, voltar e Ver no mapa | Pendente: execução Android |
| T11 | Ausência de dados/erro | Passou: vazio, erro de stream e erro de gravação com nova tentativa | Pendente: falhas reais de conexão |

“Passou localmente” não significa que o teste obrigatório de integração foi concluído. T01 e T06 exigem Firebase real. Os demais precisam também de demonstração no Android para a entrega final.

## Roteiro de conclusão

1. Configurar Firebase oficialmente e acesso aprovado; entrar pelo modal com conta autorizada.
2. Conectar celular Android com depuração USB ou configurar emulador autorizado.
3. `flutter run -d ID` e realizar T01–T11 conforme a tabela.
4. Teste automatizado somente de leitura: `flutter test integration_test/firestore_connection_test.dart -d ID`, depois de entrar no aplicativo no mesmo dispositivo e cadastrar dados.
5. Cadastrar um documento identificável para teste; fechar/reabrir o aplicativo em T06. Confirmar no Console as criações/edições/exclusões/favoritos, não somente na UI/cache.
6. Registrar resultados, dispositivo, projeto usado e capturas finais. Não executar a carga remota sem aprovação.

As imagens `previa_teste_*`, quando geradas, são renderizações de widgets com dados simulados identificados e não capturas de um Android conectado ao Firestore.

## Verificação atual em 12/10/2026

- Flutter 3.47.6/Dart 3.13.5 recuperados; flutter pub get e format passaram.
- flutter analyze --no-pub: sem problemas (via atalho ASCII do mesmo projeto para contornar erro de protocolo LSP com acentos).
- flutter test --no-pub --concurrency=2: 11 testes passaram, repetidos após configuração Firebase oficial.
- Android toolchain SDK 36/Java 21/licenças: conferidos por flutter doctor; nenhum Android conectado e nenhuma imagem de emulador disponível.
- Opções geradas pelo FlutterFire e JSON Android validados quanto a projeto/pacote/app ID. Banco remoto (default), Standard, southamerica-east1, freeTier=true confirmado administrativamente pela CLI.
- APK em compilação; T01–T11 com cliente Android/servidor continuam pendentes. Os resultados acima não comprovam autenticação nem CRUD remoto.

### Resultado do build e Authentication

- Build Android debug concluído com código 0 em 572,1 s. APK conferido por aapt2: br.edu.mapa.mapa_locais, versão 1.0.0, SDK 36.
- APK copiado para outputs/mapa-locais-firebase-debug.apk; SHA256 igual ao arquivo compilado.
- Captura do proprietário confirma provedor E-mail/senha ativado. Login de cliente, UID autorizado, regras aprovadas, carga remota e T01–T11 Android ainda pendentes.

### Liberação remota aprovada

Regras compiladas e publicadas; acesso anônimo negado com HTTP 403. Conta ativa com provedor password e authorized_users/UID confirmado. Seed remoto criou dez documentos após aprovação. Instalação e teste Android aguardam celular USB; login e CRUD pelo cliente ainda não comprovados.

### Resultado real no Android — 12/10/2026

Emulador mapa_locais_demo, Android 36 x86_64, emulator-5554; pacote br.edu.mapa.mapa_locais; Firebase mapa-de-locais-c0801. APK normal instalado e login feito pelo proprietário; lista de locais observada na UI.

`flutter test integration_test/firestore_crud_test.dart -d emulator-5554 --no-pub`: PASSOU (um teste de integração, build 180,5 s, execução 3 s). Conta aprovada persistida, projeto conferido; leitura direta Source.server sem cache; cadastro temporário, edição, favorito true/false e exclusão com confirmação no servidor. Limpeza somente do documento novo; exemplos existentes preservados. Execução em pasta temporária de build devido a bloqueios de limpeza do OneDrive. APK normal restaurado após teste.

Isso comprova leitura e CRUD pelo SDK cliente Android, com regras remotas. Não equivale a todos os testes de gestos da interface, filtros e persistência após reinicialização (T02–T04/T06/T10). Ainda registrar essas verificações específicas para a atividade.

### Conferência da interface normal

Projeto original confirmado aberto no Android Studio. Proprietário refez login após a restauração do APK. Telas Mapa, Resultados e Detalhes verificadas visualmente no emulador. Reiniciado somente o processo do app com am force-stop/am start: sessão restaurada e mapa com locais exibido, sem novo login. Captura real exportada em outputs/app-android-funcionando.png. CRUD remoto permanece aprovado pelo teste de integração; filtros e CRUD por gestos de formulário não foram integralmente testados. A IDE ainda não reconheceu os plugins instalados pela CLI, inclusive após reinício; botão Run não foi validado.


### Atualização da IDE
Plugins Flutter/Dart agora carregados e SDK reconhecido. Configuração de Run criada para reutilizar APK validado; acionamento pelo Run ainda não comprovado. O app no emulador e o teste de CRUD já foram validados independentemente da IDE.
