# Mapa de Locais

Aplicativo Android em Flutter/Dart para localizar estabelecimentos por cidade, pesquisar nome/categoria, cadastrar, editar, excluir e favoritar documentos da coleção `locais` do Cloud Firestore. Três telas principais, Material 3, azul-petróleo e mapa esquemático sem geolocalização.

## Estado desta entrega

O código de interface e o serviço Firestore estão implementados. O aplicativo inicia com uma mensagem de configuração enquanto não houver conexão real. Não há listas fixas no aplicativo. Firebase remoto, dez documentos remotos e execução Android dependem da participação do proprietário. Consulte `docs/TESTES.md` para resultados efetivamente executados.

## Ambiente e comandos

Flutter stable 3.47.6 / Dart 3.13.5, Java 25.0.3, Android SDK 36.0.0. Licenças Android aceitas. Use PowerShell na pasta deste README:

```powershell
flutter pub get
dart format lib test integration_test
flutter analyze
flutter test
flutter build apk --debug
flutter devices
flutter run -d ID_DO_DISPOSITIVO
```

O APK debug é gerado em `build/app/outputs/flutter-apk/app-debug.apk`; serve para desenvolvimento, sem assinatura de distribuição. Sem Firebase configurado, ele exibe somente o estado de configuração.

Nesta versão do SDK, `flutter analyze` falhou ao iniciar o protocolo LSP pelo caminho acentuado da Área de Trabalho; `dart analyze` passou no mesmo caminho. A análise Flutter também passou via uma junction local em `work/mapa_locais_desktop` que aponta para a mesma pasta. Em caso dessa falha da ferramenta, use `dart analyze`, sem modificar o SDK ou PATH global. `android.overridePathCheck=true` foi definido somente no gradle.properties deste projeto para permitir o caminho da Área de Trabalho.

## Configurar Firebase

Consulte `docs/FIREBASE_SETUP.md`. As CLIs foram instaladas em `.tooling` na cópia inicial do workspace, sem mudar PATH global. Nesta máquina, `.tooling_path.txt` aponta para essas ferramentas já funcionais, evitando duplicá-las na pasta OneDrive. O script de configuração e o seed usam esse ponteiro local ignorado pelo Git. Não remover a cópia inicial enquanto usar esse ponteiro. Para instalar localmente em uma cópia nova, sem o ponteiro:

```powershell
npm install --prefix .tooling firebase-tools firebase-admin
$env:PUB_CACHE = Join-Path (Get-Location) '.tooling\pub-cache'
dart pub global activate flutterfire_cli
```

O script abaixo abre o login oficial e registra/configura o aplicativo Android no projeto escolhido. Use-o apenas após escolher o projeto real e autorizar seu registro:

```powershell
.\scripts\configure_firebase.ps1 -ProjectId 'SEU_PROJECT_ID_REAL'
flutter pub get
flutter run -d ID_DO_DISPOSITIVO
```

`lib/firebase_options.dart` é criado exclusivamente pelo FlutterFire oficial. Antes disso, `firebase_bootstrap.dart` lança um erro de configuração; o script troca esse bootstrap por uma inicialização com as opções oficiais. Não existem credenciais inventadas.

Se o Console integrado encerrar a sessão, conclua o login no navegador habitual através da CLI:

```powershell
.\scripts\login_firebase.ps1
```

O código solicitado por esse fluxo é colado somente no terminal local, em entrada oculta. Não enviar pelo chat. Depois da autorização, a CLI permite criar/configurar o projeto escolhido pelo proprietário.

## Uso

Selecione São Paulo, Campinas ou Jundiaí; pesquise por nome ou categoria. Mapa e resultados usam os mesmos filtros. Categorias são descobertas nos documentos, além das três sugestões. O cadastro e a edição abrem um Bottom Sheet. Exclusão exige confirmação. Favoritos são globais por documento nesta versão. “Ver no mapa” limpa os filtros, seleciona a cidade e destaca o local em laranja no esquema. As distâncias são valores cadastrados, não calculados por GPS.

Para acessar um banco protegido, toque em Conta autorizada e entre com a conta criada pelo administrador. Não há cadastro público nem criação automática de contas.

## Dados iniciais e documentação

`data/locais_iniciais.json`: dez exemplos didáticos, cinco em São Paulo, três em Campinas, dois em Jundiaí. Somente a rotina administrativa opcional lê esse arquivo; a UI não o utiliza. `scripts/seed.cjs` exige aprovação explícita, projeto real e credenciais administrativas. Não foi executada remotamente.

Documentação: `docs/REQUISITOS.md`, `ARQUITETURA.md`, `FIREBASE_SETUP.md`, `TESTES.md`, `PROGRESSO.md`, `CHECKLIST_ENTREGA.md` e `EXTENSOES.md`. Capturas finais devem ser colocadas em `docs/capturas` após execução conectada.

Não copie chaves privadas, senhas ou contas de serviço para o projeto. `.tooling` e artefatos de compilação são ignorados pelo Git. Nenhum outro projeto foi modificado.
