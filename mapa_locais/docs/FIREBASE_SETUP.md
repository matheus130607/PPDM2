# Firebase e Firestore

## Situação atual

Projeto confirmado por captura do proprietário em 12/10/2026: **Mapa de Locais**, ID `mapa-de-locais-c0801`, número `460102444269`. `.firebaserc` aponta localmente para esse projeto. App Android oficial confirmado também pela CLI; `google-services.json` instalado, FlutterFire gerou `firebase_options.dart` e bootstrap real habilitado. Banco criado pelo proprietário e confirmado pela CLI: `(default)`, Standard, `southamerica-east1`, freeTier=true. Nenhum projeto ou banco foi criado pelo agente.

Dependências reais: firebase_core, cloud_firestore, firebase_auth (versões resolvidas em pubspec.lock). Nenhum Project ID ou opção foi inventado. As CLIs locais são encontradas por `.tooling_path.txt`. Authentication, UID autorizado, regras e carga de dados dependem das etapas e aprovações abaixo. Conexão de dados Android ainda não comprovada.

## Fluxo oficial

1. Proprietário autentica no Firebase e indica seu Project ID real. Se não houver projeto, sua criação depende de participação e aprovação.
2. Execute primeiro `scripts/login_firebase.ps1` (opcionalmente `-NoLocalhost` para o fluxo oficial com código no terminal). Após aprovação do registro Android, execute `scripts/configure_firebase.ps1 -ProjectId SEU_PROJECT_ID_REAL -ApproveRemoteRegistration`. Se as ferramentas estiverem em outro local, informe `-ToolingPath` e `-FlutterSdkPath`. O script confere o pacote, consulta projetos acessíveis e bloqueia os dois projetos excluídos do escopo antes do FlutterFire.
3. FlutterFire gera `lib/firebase_options.dart` e configura os arquivos Android. O script inicializa com `DefaultFirebaseOptions.currentPlatform` em `firebase_bootstrap.dart`. Não editar manualmente parâmetros.
4. Habilite Cloud Firestore no Console, escolhendo região e plano conscientemente. Não ativar faturamento sem aprovação.
5. Revise a estratégia de acesso abaixo e aprove as alterações remotas.
6. Ative Email/Password no Firebase Authentication, crie uma conta administrada e um documento `authorized_users/{UID}` para autorizar esse usuário. Qualquer documento existente para o UID dá acesso; somente administradores devem criar ou excluir essas autorizações.
7. Após aprovação, publique o conteúdo de `firestore.proposed.rules` pelo Console ou use `firebase deploy --project SEU_PROJECT_ID_REAL --config firebase.proposed.json --only firestore:rules`. O arquivo separado prepara a publicação da proposta. `firebase.json` agora aponta para as regras aprovadas, também copiadas em `firestore.rules`; o bloqueio original foi preservado em `firestore.lockdown.rules`.
8. Recompile, abra Conta autorizada, entre e confirme leitura. Use T01–T11 para demonstrar banco real.

## Estratégia proposta para a atividade

Leitura e CRUD somente para contas autenticadas com UID autorizado em `authorized_users`. Cliente não consegue gravar autorização. Validação dos oito campos nas regras. Nesta atividade, todos os usuários autorizados podem modificar todos os locais e favoritos; não há papéis distintos ainda. Esta política requer sua aprovação antes de publicação.

`firestore.rules` e `firestore.proposed.rules`: regras aprovadas, compiladas e publicadas em mapa-de-locais-c0801. `firestore.lockdown.rules`: bloqueio original preservado. Regras não substituem autenticação. Um banco público sem restrições não é solução de configuração.

## Carga inicial opcional e idempotente

`data/locais_iniciais.json` contém dez exemplos fictícios marcados como exemplos, distribuídos 5/3/2 entre cidades. Nenhum representa informações verificadas sobre estabelecimentos reais.

Validação offline, sem credenciais e sem Admin SDK: `node scripts/seed.cjs --dry-run`. Confere IDs únicos, oito campos, tipos, limites e cidades antes de qualquer escrita. IDs são nomes de documentos e não campos adicionais.

Após aprovação explícita, o administrador configura Application Default Credentials reais fora do projeto (por exemplo pelo fluxo oficial gcloud com conta autorizada). A autenticação `firebase login` da CLI não é automaticamente ADC do Admin SDK. Não colocar conta de serviço no repositório.

Alternativa preparada nesta máquina após aprovação da carga: `node scripts/seed.cjs --project mapa-de-locais-c0801 --approve-remote-seed --use-firebase-cli-login`. Esse modo usa a API REST oficial do Firestore com OAuth da CLI em memória, conferindo o projeto contra o JSON oficial sem exportar ou imprimir tokens. Criação atômica com ID determinístico retorna HTTP 409 quando o documento já existe, preservando-o. A autenticação usa interface interna conferida na versão fixada firebase-tools 15.33.0; uma atualização da CLI exige revalidar esse adaptador. Não transforma o login CLI em ADC e não exige instalar gcloud. IAM continua governando o acesso administrativo.

O modo padrão com ADC mantém as transações do Admin SDK. Não passar uma Credential OAuth personalizada para `getFirestore()` do Admin SDK: essa implementação aceita somente ADC ou certificado. O uso da API REST no modo CLI corrige essa incompatibilidade sem criar conta de serviço ou chave privada.

`node scripts/check_test_user.cjs UID` verifica administrativamente conta, provedor e existência da autorização, sem imprimir e-mail/senha/tokens. A criação de `authorized_users/{UID}` exige aprovação específica e flag `--approve-authorization`; cria somente se ausente e confirma a existência no servidor.

```powershell
node scripts/seed.cjs --project SEU_PROJECT_ID_REAL --approve-remote-seed
```

Transações criam IDs determinísticos apenas quando ausentes; registros existentes e alterações do usuário são preservados. Reexecução após falha parcial não duplica. Admin SDK usa IAM e contorna as regras do cliente: executar somente com a conta/projeto aprovados. A carga foi aprovada e executada em 12/10/2026: dez documentos criados e nenhum existente substituído.

## Diagnóstico

Em 12/10/2026, os caminhos anteriores de Flutter (`C:\laragon\bin\flutter`), Android SDK (`C:\laragon\bin\android-sdk`) e `.tooling_path.txt` não existiam nesta sessão. Flutter/Dart também não estavam no PATH. Os testes e o build precisam de uma instalação atual identificada ou restaurada. Não reinstalamos os pacotes do aplicativo nem alteramos PATH global.

Atualização na mesma sessão: ferramentas recuperadas no `work/mapa-tools` do workspace de 12/10/2026; ponteiro e `android/local.properties` corrigidos. Flutter 3.47.6/Dart 3.13.5, Java 21, Android SDK 36, Firebase CLI 15.33.0 e FlutterFire CLI 1.4.1 disponíveis. Login CLI e aceitação das licenças concluídos com participação/concordância do proprietário. `. ./scripts/enter_environment.ps1` prepara um terminal sem configuração global.

Correção do registro anterior sobre login: a CLI 15.33.0 suporta `login [auth_code]` no fluxo não interativo. A conclusão por código não era um argumento inválido nessa versão. O script usa agora `--interactive` explicitamente para abrir o fluxo de navegador com callback local e evitar solicitar códigos pelo chat.

`verify_firebase.ps1 -ProjectId SEU_PROJECT_ID_REAL` confere Project ID, app ID, número do projeto, pacote Android e presença do plugin Google Services antes de liberar o bootstrap. A verificação não imprime API keys. Nenhum arquivo de configuração fictício é gerado no aplicativo.

A proposta exige os oito campos do Model e autoriza por existência de `authorized_users/{UID}`. Horário e descrição podem ser strings vazias, conforme formulário. Atualizar somente favorito continua válido porque as regras recebem o documento resultante completo. Foi compilada e publicada pela CLI nesta sessão; leitura REST sem autenticação retornou 403. Validação pelo cliente Android ainda pendente.

O teste T01 agora usa `GetOptions(source: Source.server)` e verifica `isFromCache == false`; uma resposta de cache não comprova conexão real. Ainda exige uma sessão autenticada persistida no dispositivo e dados remotos autorizados.

`permission-denied`: entrar com a conta autorizada e conferir documento de autorização/regras. `unavailable`: rede ou serviço. Tela Conecte seu Firebase: configuração não realizada; recompile após script. Configuração concluída sem leitura: não declarar conectado; verificar Firestore, sessão, regras e projeto selecionado.

Referências oficiais: [Firebase Flutter](https://firebase.google.com/docs/flutter/setup), [Firestore e regras](https://firebase.google.com/docs/firestore/security/get-started), [Authentication e regras](https://firebase.google.com/docs/rules/rules-and-auth).
