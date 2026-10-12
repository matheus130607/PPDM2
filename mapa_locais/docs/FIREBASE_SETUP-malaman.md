# Firebase e Firestore

## Situação atual

Dependências reais: firebase_core, cloud_firestore, firebase_auth (versões resolvidas em pubspec.lock). Serviço pronto, mas nenhum Project ID ou opção foi inventado. As CLIs locais estão em `.tooling`. Não foram criados projeto, banco, usuários, documentos ou regras remotamente.

## Fluxo oficial

1. Proprietário autentica no Firebase e indica seu Project ID real. Se não houver projeto, sua criação depende de participação e aprovação.
   Nesta máquina, o Console no navegador integrado apresentou sessão encerrada. Execute `scripts/login_firebase.ps1` em um PowerShell local e abra o link oficial exibido no Chrome/Edge habitual. O script aceita o código de autorização em campo oculto, somente localmente. A versão 15.33.0 da CLI imprime instruções de login e retorna; um retorno de código 0 nesse ponto não significa que a conta já está autenticada. Verifique `firebase login:list` após concluir a autorização. Não enviar códigos, tokens ou senha pelo chat.
2. Execute `scripts/configure_firebase.ps1 -ProjectId SEU_PROJECT_ID_REAL`. O script usa login oficial, FlutterFire e plataforma Android; pode registrar um app remoto. Não o execute sem aprovar esse registro.
3. FlutterFire gera `lib/firebase_options.dart` e configura os arquivos Android. O script inicializa com `DefaultFirebaseOptions.currentPlatform` em `firebase_bootstrap.dart`. Não editar manualmente parâmetros.
4. Habilite Cloud Firestore no Console, escolhendo região e plano conscientemente. Não ativar faturamento sem aprovação.
5. Revise a estratégia de acesso abaixo e aprove as alterações remotas.
6. Ative Email/Password no Firebase Authentication, crie uma conta administrada e um documento `authorized_users/{UID}` para autorizar esse usuário. Qualquer documento existente para o UID dá acesso; somente administradores devem criar ou excluir essas autorizações.
7. Após aprovação, publique o conteúdo de `firestore.proposed.rules` pelo Console ou a CLI especificando esse arquivo. `firebase.json` aponta para regras de bloqueio, portanto um deploy genérico bloquearia todo o banco. Não executar deploy genérico.
8. Recompile, abra Conta autorizada, entre e confirme leitura. Use T01–T11 para demonstrar banco real.

## Estratégia proposta para a atividade

Leitura e CRUD somente para contas autenticadas com UID autorizado em `authorized_users`. Cliente não consegue gravar autorização. Validação dos oito campos nas regras. Nesta atividade, todos os usuários autorizados podem modificar todos os locais e favoritos; não há papéis distintos ainda. Esta política requer sua aprovação antes de publicação.

`firestore.rules`: nega tudo, baseline local seguro. `firestore.proposed.rules`: proposta revisável, não implantada nem ainda validada no banco. Regras não substituem autenticação. Um banco público sem restrições não é solução de configuração.

## Carga inicial opcional e idempotente

`data/locais_iniciais.json` contém dez exemplos fictícios marcados como exemplos, distribuídos 5/3/2 entre cidades. Nenhum representa informações verificadas sobre estabelecimentos reais.

Após aprovação explícita, o administrador configura Application Default Credentials reais fora do projeto (por exemplo pelo fluxo oficial gcloud com conta autorizada). A autenticação `firebase login` da CLI não é automaticamente ADC do Admin SDK. Não colocar conta de serviço no repositório.

```powershell
node scripts/seed.cjs --project SEU_PROJECT_ID_REAL --approve-remote-seed
```

Transações criam IDs determinísticos apenas quando ausentes; registros existentes e alterações do usuário são preservados. Reexecução após falha parcial não duplica. Admin SDK usa IAM e contorna as regras do cliente: executar somente com a conta/projeto aprovados. A rotina não foi executada remotamente nesta entrega.

## Diagnóstico

`permission-denied`: entrar com a conta autorizada e conferir documento de autorização/regras. `unavailable`: rede ou serviço. Tela Conecte seu Firebase: configuração não realizada; recompile após script. Configuração concluída sem leitura: não declarar conectado; verificar Firestore, sessão, regras e projeto selecionado.

Referências oficiais: [Firebase Flutter](https://firebase.google.com/docs/flutter/setup), [Firestore e regras](https://firebase.google.com/docs/firestore/security/get-started), [Authentication e regras](https://firebase.google.com/docs/rules/rules-and-auth).
