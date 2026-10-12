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
- `flutter build apk --debug`: passou na cópia inicial (376,3 s) e na pasta final da Área de Trabalho via junction (80,5 s). APK final em `apk/mapa_locais-debug.apk`, 157.946.115 bytes na compilação verificada; após mudanças, conferir a versão mais recente pelo SHA256 registrado.
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

## Verificação final da Área de Trabalho

**Onze testes passaram** na última execução após os ajustes das prévias. `flutter analyze` falhou no protocolo LSP com caminho Unicode; `dart analyze` passou diretamente e `flutter analyze` passou pelo alias local de junction para a mesma pasta. As prévias carregam fonte Segoe UI como Roboto apenas no processo de teste e a fonte MaterialIcons dos assets. O app Android usa as fontes normais de runtime. Um teste de prévia falhou por restauração tardia de variável de debug; corrigido para restaurar antes da verificação de invariantes, seguido de onze testes aprovados.

O usuário autorizou a instalação dos componentes do emulador. Emulator 37.2.12.0 e imagem API 36 Google APIs x86_64 foram instalados no SDK existente. AVD `Mapa_Locais_API_36` criado sem alterar o AVD anterior, que aponta para uma imagem API 37 ausente. `emulator -accel-check`: WHPX instalado e utilizável. Tentativa real de iniciar o novo AVD falhou por RAM/limite de memória comprometida: 877 MB restantes, 2560 MB necessários. Não houve instalação/abertura do aplicativo no emulador. Solicitação ao usuário para liberar memória; nenhum programa do usuário foi encerrado e nenhuma configuração de memória virtual foi alterada.

Após validação adicional de cidade: teste T05 direcionado passou; compilação incremental passou em 27,8 s; `dart analyze` passou. APK atualizado, 173.847.941 bytes. SHA256: `C1A25B40DB3B90E9CFF0653FBC1B24D671C1836BF84142803889E5B5AC4A1231`.

Login Firebase verificado: Console integrado exibe sessão encerrada; nenhuma conta autenticada na CLI. `firebase login` oficial executado: forneceu fluxo no site auth.firebase.tools e instrução para retornar código local; não produziu sessão autenticada. Preparado `scripts/login_firebase.ps1` com entrada oculta de código, sintaxe PowerShell validada sem executar autenticação nem mostrar códigos. Usuário conclui consentimento no navegador habitual.
