# Mapa de Locais

Aplicativo Android em Flutter/Dart para localizar estabelecimentos por cidade, pesquisar nome/categoria, cadastrar, editar, excluir e favoritar documentos da coleção `locais` do Cloud Firestore. Três telas principais, Material 3, azul-petróleo e mapa esquemático sem geolocalização.

## Estado desta entrega

Firebase Android configurado oficialmente para `mapa-de-locais-c0801`, com opções geradas pelo FlutterFire e Google Services conferido. Banco `(default)` confirmado na edição Standard, região `southamerica-east1`, com freeTier=true. Email/senha ativado, conta de teste autorizada, regras publicadas e dez exemplos inseridos com aprovação. App executado no emulador Android 36, login confirmado e teste real de leitura/CRUD/favoritos/exclusão aprovado. Consulte docs/TESTES.md para limites das verificações da UI. Não há listas fixas no aplicativo. Consulte `docs/TESTES.md` para resultados efetivamente executados.

## Ambiente e comandos

Flutter 3.47.6 / Dart 3.13.5, Java Temurin 21, Android SDK 36. Licenças Android aceitas. Use PowerShell na pasta deste README:

Em 12/10/2026, as ferramentas ausentes foram recuperadas localmente com Flutter 3.47.6, Dart 3.13.5, Java Temurin 21 e Android SDK 36. Antes dos comandos abaixo, execute `. ./scripts/enter_environment.ps1` para ajustar somente o terminal atual. `.tooling_path.txt` contém o caminho atual; preserve essa pasta de ferramentas. Não foi necessário mudar PATH global.

Flutter 3.47.6 apresenta falha de protocolo do analyzer com o caminho contendo `Área de Trabalho`. Nesta sessão, analyze/test/build foram executados pelo atalho de diretório ASCII `work/mapa-project` no workspace indicado em `docs/PROGRESSO.md`; ele aponta para esta mesma pasta, sem duplicar o aplicativo.

```powershell
flutter pub get
dart format lib test integration_test
flutter analyze
flutter test
flutter build apk --debug
flutter devices
flutter run -d ID_DO_DISPOSITIVO
```

O APK debug é gerado em `build/app/outputs/flutter-apk/app-debug.apk`; serve para desenvolvimento, sem assinatura de distribuição. A configuração Firebase existe; o acesso aos dados exige provedor, usuário autorizado e regras publicados.

## Configurar Firebase

Consulte `docs/FIREBASE_SETUP.md`. Nesta máquina, `.tooling_path.txt` aponta para as ferramentas recuperadas em `work/mapa-tools` no workspace de 12/10/2026, evitando duplicá-las na pasta OneDrive. O script de configuração e o seed usam esse ponteiro local ignorado pelo Git. Preserve a pasta indicada no ponteiro. Para instalar localmente em uma cópia nova, sem o ponteiro:

```powershell
npm install --prefix .tooling firebase-tools firebase-admin
$env:PUB_CACHE = Join-Path (Get-Location) '.tooling\pub-cache'
dart pub global activate flutterfire_cli
```

O script abaixo abre o login oficial e registra/configura o aplicativo Android no projeto escolhido. Use-o apenas após escolher o projeto real e autorizar seu registro:

```powershell
.\scripts\login_firebase.ps1
.\scripts\configure_firebase.ps1 -ProjectId 'SEU_PROJECT_ID_REAL' -ApproveRemoteRegistration
flutter pub get
flutter run -d ID_DO_DISPOSITIVO
```

`lib/firebase_options.dart` é criado exclusivamente pelo FlutterFire oficial. Antes disso, `firebase_bootstrap.dart` lança um erro de configuração; o script troca esse bootstrap por uma inicialização com as opções oficiais. Não existem credenciais inventadas.

O app Android já registrado nesta sessão foi reutilizado com `-UseExistingAndroidApp`; esse modo confirma o app ID do JSON oficial na lista remota antes de configurar. Não é necessário registrar novamente.

## Uso

Selecione São Paulo, Campinas ou Jundiaí; pesquise por nome ou categoria. Mapa e resultados usam os mesmos filtros. Categorias são descobertas nos documentos, além das três sugestões. O cadastro e a edição abrem um Bottom Sheet. Exclusão exige confirmação. Favoritos são globais por documento nesta versão. “Ver no mapa” limpa os filtros, seleciona a cidade e destaca o local em laranja no esquema. As distâncias são valores cadastrados, não calculados por GPS.

Para acessar um banco protegido, toque em Conta autorizada e entre com a conta criada pelo administrador. Não há cadastro público nem criação automática de contas.

## Dados iniciais e documentação

`data/locais_iniciais.json`: dez exemplos didáticos, cinco em São Paulo, três em Campinas, dois em Jundiaí. Somente a rotina administrativa opcional lê esse arquivo; a UI não o utiliza. `scripts/seed.cjs` exige aprovação explícita, projeto real e credenciais administrativas. Carga remota aprovada e executada: dez documentos criados, sem sobrescrever existentes.

Documentação: `docs/REQUISITOS.md`, `ARQUITETURA.md`, `FIREBASE_SETUP.md`, `TESTES.md`, `PROGRESSO.md`, `CHECKLIST_ENTREGA.md` e `EXTENSOES.md`. Capturas finais devem ser colocadas em `docs/capturas` após execução conectada.

Não copie chaves privadas, senhas ou contas de serviço para o projeto. `.tooling` e artefatos de compilação são ignorados pelo Git. Nenhum outro projeto foi modificado.
