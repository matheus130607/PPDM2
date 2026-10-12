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

## Etapa 7 — continuação Firebase em 12/10/2026

- Proprietário informou que Mapa de Locais ainda não existe e autorizou sua criação em plano Spark, sem faturamento. Não foi possível criar: Chrome habitual não está conectado ao controle de navegador. O navegador do Codex abriu login; após participação do usuário, mostrou erro ao carregar o status de aceitação dos Termos de Serviço; Tentar novamente retornou ao login. Não há Project ID confirmado e nenhum recurso remoto foi alterado.
- Pacote confirmado em applicationId, namespace e MainActivity: br.edu.mapa.mapa_locais. Gradle existente preservado (AGP 9.1.0 / Kotlin 2.4.0). Plugin Google Services ainda depende da configuração oficial e verificação posterior.
- Confirmadas ausências dos caminhos antigos de Flutter, Android SDK e ferramentas locais. Flutter/Dart não disponíveis no PATH. Busca nos locais usuais não encontrou uma instalação utilizável. Não foram executados pub get, dart format, analyze, flutter test ou build nesta sessão; resultados antigos não são validações atuais.
- Memória livre no início: aproximadamente 5,9 GiB de 15,4 GiB. Nenhum emulador iniciado. Sem adb utilizável identificado, não foi possível revalidar o estado dos dispositivos Android.
- Corrigido login_firebase.ps1: removida segunda solicitação de código e chamada incorreta firebase login com código como argumento. O fluxo oficial da CLI administra login; opção NoLocalhost disponível. Senhas/tokens não registrados em logs.
- configure_firebase.ps1 agora verifica ferramentas, pacote, Project ID acessível e projetos fora do escopo; exige aprovação explícita para registro remoto; não inicia login inesperado. Suporta caminhos atuais explícitos, sem mudar PATH/PUB_CACHE permanentemente.
- Novo verify_firebase.ps1 verifica correspondência de projeto, número do projeto, app ID, pacote e plugin Google Services antes de habilitar bootstrap. Firebase options/google-services não fabricados; bootstrap bloqueante mantido até configuração real.
- firebase.proposed.json preparado para deploy explícito de firestore.proposed.rules. firebase.json permanece no baseline de bloqueio. Nenhuma regra publicada.
- Proposta revisada contra Model, formulário e serviço: oito campos compatíveis, autorização por UID, cidades aceitas, favoritos parciais permitidos mediante documento final válido. Compilação/execução das regras ainda pendente.
- Seed ganhou validação dos dados antes de escrever e modo dry-run independente de dependências administrativas. Verificação local passou: dez documentos válidos e IDs únicos; nenhuma conexão remota.
- T01 corrigido para leitura Source.server com verificação de metadados; evita declarar cache como prova de conexão. Teste real não executado.
- Sintaxe dos três scripts PowerShell, node --check e JSON de deploy verificados com sucesso. Documentação de configuração atualizada.

### Próxima ação necessária

Restabelecer acesso ao Console autenticado (ou concluir a criação no Chrome habitual e informar somente o Project ID real). Identificar/restaurar Flutter SDK, Android SDK e ferramentas CLI atuais antes da configuração Android. Registro Android, criação do banco, provedor/conta de teste, autorização UID, publicação de regras e carga remota permanecem etapas distintas sujeitas à aprovação solicitada pelo proprietário. Região proposta southamerica-east1 (São Paulo), se disponível ao criar (default); não alterar banco existente.

## Etapa 8 — projeto real confirmado em 12/10/2026

- Captura enviada pelo proprietário confirma nome Mapa de Locais, Project ID mapa-de-locais-c0801 e número 460102444269. A pendência de identificação do projeto está resolvida.
- Criado .firebaserc com esse projeto padrão local; JSON validado. Nenhum comando remoto executado e nenhum outro projeto alterado.
- A captura não permite confirmar plano Spark, apps registrados, Firestore ou Authentication. Não presumimos que essas etapas estejam concluídas.
- Ferramentas rechecadas: Flutter/Dart/CLIs ainda ausentes do PATH e caminhos antigos indisponíveis. Não há instalação encontrada nos caminhos usuais nem nos caminhos equivalentes consultados em Windows.old. Configuração FlutterFire e testes continuam bloqueados pelas ferramentas ausentes.
- Próxima etapa: registrar (ou confirmar registro existente de) app Android br.edu.mapa.mapa_locais no projeto confirmado e obter google-services.json oficial; identificar/restaurar ferramentas locais para gerar firebase_options.dart e validar Gradle. Criação do projeto autorizada anteriormente; alterações remotas subsequentes continuam sujeitas à aprovação solicitada pelo proprietário.

## Etapa 9 — ferramentas recuperadas e configuração Android oficial (12/10/2026)

- google-services.json enviado pelo proprietário conferido: projeto mapa-de-locais-c0801, número 460102444269, pacote br.edu.mapa.mapa_locais, app ID 1:460102444269:android:8d0da47870b2eb6573d8e4. Instalado em android/app; CLI confirmou o mesmo app existente.
- Ferramentas antigas não foram localizadas em busca ampliada. Recuperadas em C:\Users\mathe\Documents\Codex\2026-10-12\files-pasted-by-the-user-continua\work\mapa-tools: Flutter 3.47.6 da tag oficial (commit 5fc346839b), Dart 3.13.5, Temurin Java 21.0.12.1, Android command-line tools, SDK platform/build-tools 36, platform-tools, Firebase CLI 15.33.0, Admin SDK e FlutterFire CLI 1.4.1. Não houve pub upgrade do aplicativo nem alteração de PATH global.
- Download do índice de releases Flutter retornou NoSuchKey; recuperada tag oficial via Git. Checkout falhou inicialmente por caminhos longos; core.longpaths habilitado somente no checkout novo, e restore concluiu. Flutter doctor avisa canal user-branch devido ao uso da tag fixa; versão/commit preservados, sem upgrade automático.
- Hashes SHA256 dos ZIPs JDK e Android command-line tools conferidos. Android tools hash: 90ae805d20434428bffcb699c290860f19bb5f66a67e6b330067e3de801fb04a.
- Login OAuth Firebase concluído pelo proprietário no navegador. Gemini e telemetria opcional recusados. login_firebase.ps1 atualizado para --interactive. Corrigido diagnóstico anterior: login com código é suportado por esta versão da CLI no fluxo não interativo, conforme código instalado; não era argumento inválido.
- Licenças Android revisadas em terminal aberto ao proprietário; após resposta concordo, aceitação concluída. flutter doctor confirma Android toolchain e licenças. Nenhum celular Android conectado e nenhuma fonte de emulador disponível; nenhum emulador iniciado.
- .tooling_path.txt e android/local.properties corrigidos; enter_environment.ps1 prepara somente o terminal. Atalho de diretório work/mapa-project aponta ao aplicativo original para contornar bug do analyzer Flutter 3.47.6 em Content-Length com Unicode (Área de Trabalho). Não houve cópia/recriação do aplicativo nem alteração do código do SDK para esse contorno.
- Google Services 4.5.0 adicionado em settings/app Gradle conforme documentação oficial atual. Configuração FlutterFire executada com projeto confirmado e app Android existente; gerou firebase_options.dart e habilitou bootstrap. verify_firebase.ps1 conferiu Project ID, app ID, número do projeto, pacote e plugins sem mostrar API keys.
- Gradle reduzido de Xmx8G/metaspace4G para Xmx3G/metaspace1G, dois workers e paralelismo desativado; cache de build isolado em work/mapa-tools/gradle-cache. RAM livre inicial cerca de 5,9 GiB; sem emulador concorrente.
- flutter pub get passou; dart format nos arquivos Dart modificados passou. flutter analyze inicialmente falhou no protocolo LSP por caminho com acentos; passou via atalho ASCII. flutter test --concurrency=2: 11 testes passaram. Analyze/test repetidos após opções oficiais geradas: sem problemas e 11 testes passaram.
- Leitura administrativa da lista de bancos inicialmente retornou 403 por API desativada. Proprietário criou Firestore; nova consulta confirmou banco (default), Standard, FIRESTORE_NATIVE, southamerica-east1 e freeTier=true. Isso comprova existência do banco, não CRUD pelo app Android.
- Regras copiadas para outputs/regras-firestore-propostas.rules para revisão; aprovação de publicação solicitada. Não houve publicação até este registro.
- Seed opcional preparado para reutilizar OAuth CLI em memória (flag explícita), evitando nova instalação gcloud/ADC; projeto conferido contra arquivo oficial. Dados e sintaxe validados offline; nenhuma carga remota executada até este registro.
- APK debug em compilação. Authentication/conta de teste/UID e aprovação de regras ainda em andamento. Sem execução Android e sem teste remoto de CRUD até este registro.

## Etapa 10 — APK validado e provedor ativado (12/10/2026)

- flutter build apk --debug --no-pub concluiu com código 0 em 572,1 segundos, usando o mesmo aplicativo pelo atalho ASCII. APK em build/app/outputs/flutter-apk/app-debug.apk, 157.971.315 bytes.
- aapt2 confirmou pacote br.edu.mapa.mapa_locais, versão 1.0.0/code 1, compile/target SDK 36 e rótulo Mapa de Locais. Cópia entregue em outputs/mapa-locais-firebase-debug.apk no workspace de 12/10/2026; hash SHA256 da cópia comparado ao original e idêntico.
- Build emitiu avisos das dependências Firebase sobre Kotlin Gradle Plugin e XML Android SDK, além de operações Java não verificadas. Não impediram a compilação; versões das dependências do app preservadas. Platform 34 e NDK 28.2.13676358 instalados automaticamente pelo build quando necessários.
- Daemon Gradle deste cache isolado parado após o build para liberar memória. Nenhum emulador iniciado.
- Captura do proprietário confirma E-mail/senha ativado no Firebase Authentication. Conta de teste e UID ainda não recebidos; login efetivo do cliente ainda não testado.
- Aprovação para publicar firestore.proposed.rules solicitada e pendente. Nenhuma regra publicada, documento de autorização gravado ou carga remota feita nesta sessão até este registro.
- Próxima ação do proprietário: Authentication → Usuários → Adicionar usuário, criar conta de teste com senha exclusiva para o app e informar somente UID; aprovar a política proposta. Depois configurar authorized_users/{UID} e dados iniciais com autorização e testar no Android real.

## Etapa 11 — acesso e dados liberados (12/10/2026)

- Proprietário aprovou publicação das regras: CLI compilou e publicou no projeto mapa-de-locais-c0801. Regras aprovadas copiadas para firestore.rules; baseline preservado em firestore.lockdown.rules.
- Consulta REST anônima à coleção locais retornou 403 PERMISSION_DENIED, confirmando bloqueio sem autenticação.
- UID PJeJ3MtAjId4sIZHN7xtFuq1O9B2 verificado: conta ativa com provedor password. Após autorização explícita, criado authorized_users/UID e existência confirmada no servidor.
- Carga remota explicitamente autorizada e concluída: dez documentos criados, zero existentes sobrescritos, usando API REST com OAuth administrativo da CLI.
- Proprietário escolheu celular USB com depuração. adb devices ainda não detectou aparelho. Instalação, abertura e login reais no Android aguardam conexão do celular; verificações administrativas não substituem teste do cliente.

## Etapa 12 — teste solicitado no Android Studio (12/10/2026)

- Proprietário preferiu testar no emulador do computador em vez do celular USB. O aparelho não recebeu instalação.
- Android Studio não encontrado nas pastas/programas consultados. Download oficial 2026.2.1.8 e imagem Google APIs API 36 x86_64 iniciados; arquivos parciais preservados na reinicialização, downloads retomados com HTTP Range.
- Placa Gigabyte A520M DS3H e Ryzen 5 5600G identificados. SVM estava desativada; proprietário a ativou na BIOS. Win32_Processor agora confirma VirtualizationFirmwareEnabled=True.
- HypervisorPresent=False e accel-check acusa ausência de driver. Driver oficial AEHD 2.2 baixado e SHA1 validado contra catálogo oficial. Instalação administrativa aguarda consentimento do Windows pelo proprietário.
- Aplicativo ainda não executado em Android; não declarar login/CRUD validados até execução do cliente.

## Etapa 13 — aplicativo e teste real no Android (12/10/2026)

- Android Studio Rabbit 1 2026.2.1.8 instalado; SHA256 do instalador oficial validado. Plugins Flutter 97.0.0 e Dart 510.0.0 instalados pela CLI oficial da IDE.
- Imagem Android 36 Google APIs x86_64 baixada e SHA1 validado contra catálogo oficial. AVD mapa_locais_demo criado com dois núcleos, 1536 MB e tela 720x1280. AEHD 2.2 operacional após permissão administrativa do proprietário.
- APK instalado no emulator-5554 com Success e MainActivity aberta. Proprietário efetuou login; captura da UI confirmou os locais reais e ações de cadastro/edição/favoritos.
- Android Studio lançado diretamente pelo terminal do agente falhou em .port/UnixDomainSockets bind. Abertura pelo shell do Windows resolveu a inicialização e a tela Welcome apareceu. Não houve reset de configurações/plugins nem alteração do código do aplicativo para essa correção.
- Compilação do novo teste de integração no projeto OneDrive falhou ao limpar arquivos de build. Usada cópia temporária de compilação work/mapa-verificacao, preservando o projeto original. Cópia encontrou placeholders OneDrive indisponíveis em arquivos auxiliares (.idea/.metadata/gradlew Unix e outros); arquivos necessários ao debug conferidos e resolução offline das mesmas dependências concluída. OneDrive iniciado pelo shell do Windows para restabelecer o provedor.
- flutter test integration_test/firestore_crud_test.dart -d emulator-5554 --no-pub passou: um teste de integração real; build 180,5 segundos e teste 3 segundos. Verificados projeto/UID aprovado, leitura Source.server sem cache, criação de documento temporário com oito campos, edição nome/horário, favorito true/false e exclusão confirmada no servidor. Dez exemplos existentes não modificados pelo teste.
- APK normal entregue em outputs reinstalado após o teste para não deixar a interface de teste no emulador. A restauração do APK não manteve a sessão; proprietário entrou novamente e a UI voltou a exibir os locais. Daemon Gradle parado para liberar RAM.
- Seleção do projeto correto na IDE em conclusão. Navegação/filtros da UI ainda precisam de validação manual específica; teste de CRUD valida o SDK real, não todos os gestos do formulário.


## Etapa 14 — projeto aberto e sessão normal (12/10/2026)

- Confirmado Android Studio com título mapa_locais e árvore do caminho original correto. Problema do seletor resolvido com a navegação manual do proprietário.
- Proprietário refez login na versão normal; mapa, resultados e detalhes de Academia Horizonte (exemplo) observados no emulador.
- Configuração de execução pelo botão Run da IDE e testes de filtros/persistência ainda não confirmados. O app normal está instalado e aberto no emulador; CRUD no servidor já passou no teste de integração.


- Reinicialização do app normal confirmou sessão persistida e mapa exibido sem novo login. Captura real em outputs/app-android-funcionando.png.
- IDE reiniciada pelo shell e reabriu o projeto correto. Ainda não reconheceu os plugins instalados pela CLI; botão Run não validado. Aplicativo normal permanece funcionando no emulador.


## Etapa 15 — plugins e preparação da IDE (12/10/2026)

- Proprietário aprovou a instalação pela interface da IDE. Plugins Flutter 97.0.0 e Dart 510.0.0 efetivamente carregados, confirmados no log da IDE após reinício.
- Metadados .idea do OneDrive indisponíveis preservados em .idea-onedrive-preservada-20261012; criada configuração local de módulo/Dart SDK e execução “Mapa de Locais - APK validado”. Ela reutiliza o APK já compilado; alterações no código exigem reconstruir esse APK.
- Assistente SDK Components Setup não permitiu substituir o caminho nem ao proprietário. Cancelado sem instalar API 37. SDK existente registrado via android.sdk.path.xml/ProjectJdkTable, seguindo esquema do código AndroidX/AIDEGen. Caminho correto confirmado visualmente nas configurações.
- SDK parcial no caminho padrão preservado em AppData/Local/Android/Sdk-preservado-20261012 e criado atalho de diretório para o SDK completo existente. Diagnóstico executado no ambiente normal do Windows confirmou emulator-5554 Android 36 suportado. Descoberta pelo daemon Flutter da IDE e botão Run ainda em ajuste.
- .gitignore atualizado para excluir backups locais da IDE, APKs/AABs e arquivos .env. Arquivos antigos do OneDrive continuam indisponíveis; recuperar antes de publicar a árvore completa. Nenhum upload/commit/push executado.
