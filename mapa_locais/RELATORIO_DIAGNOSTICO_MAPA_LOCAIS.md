# RELATÓRIO DE DIAGNÓSTICO — MAPA_LOCAIS

Auditoria em 12/10/2026, horário de São Paulo. Escopo: diagnóstico do projeto existente, sem implementar correções. Única alteração autorizada: criação deste relatório.

## 1. Resumo executivo

O projeto Flutter correto foi localizado na Área de Trabalho redirecionada ao OneDrive. As três telas, o modelo de dados, os formulários, os filtros, a autenticação por e-mail/senha e o serviço CRUD do Firestore estão escritos. **A conexão Firebase ainda não está configurada no aplicativo.** O arquivo `lib/firebase_bootstrap.dart` lança uma exceção incondicional, em vez de inicializar o Firebase; não existem `lib/firebase_options.dart` nem `android/app/google-services.json`. Consequentemente, o aplicativo atual mostra “Conecte seu Firebase”; não chega a construir o serviço de banco nem disponibiliza o botão de login.

Nenhum Project ID real foi encontrado na configuração do aplicativo. A existência de projeto, aplicativo registrado, banco, documentos e regras publicados no Console **não foi verificada remotamente nesta auditoria**. A informação anterior do usuário foi que ainda não havia criado o projeto; se ele foi criado depois, deve ser reutilizado.

O ambiente consegue compilar Android segundo os registros anteriores e existe um APK debug cujo hash foi conferido agora. Isso não comprova execução em Android ou persistência remota. O diagnóstico atual encontra SDK e licenças válidos, dois AVDs cadastrados e `emulator-5554` offline. Não há dispositivo Android pronto para execução. A memória livre está muito baixa.

## 2. Localização, identificação e método

Pasta auditada:

```text
C:\Users\mathe\OneDrive\Área de Trabalho\mapa_locais
```

O caminho foi obtido pela pasta especial Desktop do Windows, considerando o redirecionamento. Identidade confirmada pelo `pubspec.yaml`: `name: mapa_locais`, versão `1.0.0+1`, projeto Flutter/Dart com plataforma Android.

Foram lidos arquivos de aplicação, plataforma Android, dependências, regras, scripts, dados, testes e documentação. Foram consultados Flutter/Dart, doctor, dispositivos, emuladores, Java, Git, Node e memória do Windows. Foram registrados hashes dos 77 arquivos existentes fora das pastas de artefatos/caches `.git`, `.dart_tool`, `.tooling`, `.gradle` e `build`, para comparação ao término. O relatório é excluído dessa comparação por ser a única criação autorizada.

Não foram executados `pub get`, testes, análise que gere artefatos, compilação, login, configuração FlutterFire, publicação de regras, carga de dados, instalação ou inicialização de emulador. Os resultados de testes/build anteriores são identificados como históricos, com base em `docs/TESTES.md`; não foram repetidos nesta auditoria. Consultas de ferramentas podem usar seus caches globais, mas não houve comando de alteração dos arquivos do projeto.

## 3. Ambiente Flutter e Android

| Componente | Evidência e situação |
|---|---|
| Flutter | 3.47.6 stable, SDK em `C:\laragon\bin\flutter` |
| Dart | 3.13.5; corresponde à restrição `sdk: ^3.13.5` |
| Android SDK | `C:\laragon\bin\android-sdk`; doctor valida platform/build-tools 36.0.0 e licenças aceitas |
| Android Studio | Instalação em `C:\Program Files\Android\Android Studio`; executável e JBR presentes |
| Java usado pelo Flutter | OpenJDK 25.0.3 do Android Studio; alvo Java/Kotlin do app é JVM 17 |
| Gradle / AGP / Kotlin | Wrapper 9.3.1, Android Gradle Plugin 9.1.0, Kotlin declarado 2.4.0 |
| Emulator | 37.2.12.0 instalado; AVD `Mapa_Locais_API_36` com imagem Google APIs x86_64 |
| Outro AVD | `Medium_Phone_API_37.0` cadastrado; documentação registra imagem correspondente ausente |
| Dispositivos atuais | Windows, Chrome e Edge; Android `emulator-5554` offline |
| Doctor | “No issues found”, com aviso explícito de emulador offline; isso não significa Android executável |
| Memória | Consulta pontual: 7.664.432 KiB de RAM utilizável e 50.360 KiB livres, aproximadamente 7,31 GiB / 49 MiB; valores variam |
| Git / Node | Git 2.56.0.windows.2; Node 24.20.0 |
| CLIs auxiliares | Documentação/tooling local: Firebase CLI 15.33.0 e FlutterFire CLI 1.4.1; sessão autenticada atual não consultada |

Dependências declaradas: Flutter SDK, `cupertino_icons ^1.0.8`, `firebase_core ^4.15.0`, `cloud_firestore ^6.10.0`, `firebase_auth ^6.7.0`; desenvolvimento: `flutter_test`, `integration_test` e `flutter_lints ^6.0.0`. Há lockfile e resolução local prévia. O conjunto foi compilado anteriormente; não há evidência local de conflito de dependências. Uma nova resolução/build, especialmente depois da configuração Firebase, permanece fora do escopo deste diagnóstico.

**Possibilidade de compilação:** historicamente comprovada para debug. Existe `apk/mapa_locais-debug.apk`, 173.847.941 bytes, SHA256 conferido:

```text
C1A25B40DB3B90E9CFF0653FBC1B24D671C1836BF84142803889E5B5AC4A1231
```

**Possibilidade de execução Android agora:** pendente de dispositivo online e memória disponível. O histórico registra falha real do AVD por limite de memória comprometida, mesmo com aceleração WHPX disponível. `org.gradle.jvmargs` permite heap de 8 GiB e metaspace de 4 GiB; os limites não são alocação imediata, mas são elevados para esta máquina e podem competir com o emulador.

O caminho com acentos já causou falha no protocolo LSP de `flutter analyze`. O histórico registra sucesso de `dart analyze` e de `flutter analyze` pela junction ASCII existente em `C:\Users\mathe\Documents\Codex\2026-10-11\files-pasted-by-the-user-projeto\work\mapa_locais_desktop`, apontando à mesma pasta Desktop. `android.overridePathCheck=true` já está no projeto. Nenhuma dessas configurações foi alterada agora.

O build release ainda usa assinatura debug. A compilação debug existente atende demonstração técnica, mas não comprova prontidão para publicação em loja.

## 4. Arquitetura atual

| Área | Arquivos/pastas e responsabilidade |
|---|---|
| Entrada | `lib/main.dart`: prepara binding, chama bootstrap, cria serviço se houver sucesso e inicia app |
| Inicialização Firebase | `lib/firebase_bootstrap.dart`: atualmente bloqueio explícito de configuração |
| Aplicação/estado | `lib/app.dart`: tema Material 3, navegação, stream compartilhado, filtros, seleção e ações |
| Modelo | `lib/models/local.dart`: conversão Firestore ↔ Local; ID vem do documento |
| Dados | `lib/services/local_service.dart`: interface injetável `LocalRepository` e implementação `LocalService` |
| Telas | `lib/screens/mapa_screen.dart`, `resultados_screen.dart`, `detalhes_screen.dart` |
| Formulário/login | `lib/widgets/local_form.dart`, `login_dialog.dart` |
| Utilitários | Filtros, normalização de busca, feedback e confirmação de exclusão |
| Firebase local | `firebase.json`, `firestore.rules` e `firestore.proposed.rules` |
| Preparação operacional | `scripts/configure_firebase.ps1`, `login_firebase.ps1`, `seed.cjs` |
| Exemplos | `data/locais_iniciais.json`: dez registros didáticos fictícios |
| Testes | `test/app_test.dart`, `local_test.dart`, `preview_test.dart`; integração separada em `integration_test/` |
| Documentação | README e `docs/ARQUITETURA.md`, `REQUISITOS.md`, `FIREBASE_SETUP.md`, `TESTES.md`, `PROGRESSO.md`, `CHECKLIST_ENTREGA.md`, `EXTENSOES.md`; prévias em capturas |
| Plataforma/artefatos | `android/`, metadados do editor/Flutter, artefatos de build e APK em `apk/` |

O estado é mantido no widget raiz, sem biblioteca adicional de gestão de estado. Um único `snapshots()` alimenta telas e detalhes; filtros e ordenação são locais. Os repositórios substitutos pertencem aos testes: o aplicativo não apresenta a lista fictícia como se fosse um backend real.

A ferramenta local está na cópia original dentro de `outputs`; `.tooling_path.txt` aponta para ela. Mover/copiar apenas a pasta Desktop para outro computador pode quebrar os scripts. A raiz Git existe, mas os arquivos estavam sem commits/remotes na consulta: falta histórico recuperável de versionamento.

## 5. Auditoria das funcionalidades

“Implementada” abaixo significa código/interface presentes. A coluna de integração separa o que ainda precisa ser demonstrado com o servidor.

| Funcionalidade | Classificação | Evidência e limite |
|---|---|---|
| Mapa: seleção de cidade | Implementada | Dropdown com São Paulo, Campinas, Jundiaí e cidades presentes nos documentos; filtra em memória |
| Mapa: pesquisa | Implementada | Nome/categoria, normalização de caixa e acentos; depende de dados carregados |
| Mapa: representação visual | Implementada | `CustomPainter`, mapa esquemático claramente identificado |
| Mapa: geolocalização/mapa geográfico | Não implementada | Não há GPS, coordenadas ou SDK de mapas; extensão, sem presumir obrigatoriedade |
| Mapa: marcadores e abertura | Implementada | Um marcador clicável por registro filtrado; destaque por ID e abertura de detalhes |
| Mapa: cinco ou mais marcadores | Parcialmente implementada | Depende de pelo menos cinco documentos na cidade/filtros atuais; dados locais de carga contêm cinco em São Paulo, ainda não confirmados no servidor |
| Navegação entre três telas | Implementada | Resultados, detalhes, voltar e “Ver no mapa”; estado selecionado pelo ID |
| Resultados: consulta em tempo real | Parcialmente implementada | Serviço com `snapshots()` pronto; inicialização impede conexão real |
| Resultados: filtros | Implementada | Cidade, categoria, pesquisa e favoritos combinados |
| Cadastro | Parcialmente implementada | Formulário e `.add()` prontos; gravação remota não comprovada |
| Edição | Parcialmente implementada | Dados preenchidos, ID mantido e `.update()`; persistência remota pendente |
| Exclusão | Parcialmente implementada | Confirmação, bloqueio de repetição e `.delete()`; exclusão remota pendente |
| Detalhes: nome/categoria/cidade/descrição | Implementada | Exibe o documento selecionado; reage ao stream e à remoção |
| Detalhes: horário/avaliação/distância | Implementada | Campos apresentados com tratamento de ausências |
| Detalhes: favoritos | Parcialmente implementada | Botão e atualização isolada do campo prontos; servidor não testado |
| Detalhes: “Ver no mapa” | Implementada | Seleciona cidade, limpa filtros/pesquisa e destaca ID no esquema |
| Imagem real do estabelecimento | Não implementada | Representação visual de placeholder; não há upload/Storage |
| Login do aplicativo | Parcialmente implementada | `signInWithEmailAndPassword` e logout presentes; exige Core, provedor e usuário remoto |
| Tratamento de vazio/loading/erros | Implementada | Indicador, estado vazio, erro, nova tentativa e mensagens de operações |
| Persistência após fechar/reabrir | Não verificada | Sem validação com Firebase real e dispositivo Android |
| Execução visual em Android | Não verificada | Prévias de widgets não equivalem a capturas de Android conectado |

Favorito é **global por estabelecimento**, compartilhado por todos os usuários autorizados; o esquema não possui favoritos individuais. Distância é cadastrada manualmente em quilômetros e não calculada a partir da localização do celular. Todos os locais são baixados e filtrados no cliente: adequado ao conjunto didático pequeno, com custo/escala a reavaliar para grandes volumes.

## 6. Diagnóstico Firebase e consistência dos dados

### Firebase Core e identificação

| Verificação | Resultado |
|---|---|
| Dependência Core | Declarada; lock/cache e histórico de build existentes |
| `lib/firebase_options.dart` | Ausente |
| Inicialização | `main.dart` chama `initializeBackend()`, mas o bootstrap lança `StateError` incondicionalmente |
| Tratamento da falha inicial | `catch (_) {}` descarta a causa e deixa repositório nulo; tela genérica de configuração |
| Project ID configurado | Nenhum identificado na configuração ativa |
| Application ID Android | `br.edu.mapa.mapa_locais` |
| Namespace Android | `br.edu.mapa.mapa_locais`, consistente com o Application ID |
| Android registrado no Console | Não verificado; acesso remoto não realizado |
| `android/app/google-services.json` | Ausente; conteúdo e correspondência não verificáveis |
| Plugin Google Services no Gradle | Ausente; configuração nativa ainda não preparada |
| Divergência entre IDs | Não existe ID Firebase local para comparar; não inventar equivalência entre nome de projeto, Project ID e Application ID |

A ausência de JSON, isoladamente, não prova falha em toda integração Flutter: opções Dart explícitas podem inicializar Firebase. Aqui o impedimento é inequívoco pela combinação de bootstrap que lança erro e ausência de opções. Baixar apenas o JSON não corrige esse fluxo.

### Cloud Firestore e permissões

`cloud_firestore` está declarado. `LocalService` usa `FirebaseFirestore.instance.collection('locais')`, portanto o banco padrão `(default)`. Métodos presentes: `listarLocais()` com `snapshots()`, `adicionar()` com `add`, `atualizar()` com `update`, `excluir()` com `delete` e `alterarFavorito()` com update do booleano. A ordenação por nome ocorre no cliente; estas consultas não exigem índice composto adicional.

Não há evidência de leitura ou escrita remota bem-sucedida. `firestore.rules` bloqueia tudo. `firebase.json` aponta a esse arquivo, **não à proposta**. Publicar a configuração local atual manteria o bloqueio. `firestore.proposed.rules` restringe acessos a usuários autenticados com documento `authorized_users/{UID}`, valida exatamente os oito campos e bloqueia as demais coleções aos clientes. É uma proposta local, não evidência de publicação.

Os usuários autorizados podem ler, criar, editar e excluir qualquer local. Não existem papéis separados de administrador/leitor. O controle de autorização usa existência do documento; um campo `ativo: false` NÃO revoga acesso. A gestão dessa coleção deve ser administrativa. Para a atividade com usuários selecionados, a proposta evita acesso público irrestrito; papéis e favoritos individuais exigiriam mudança de modelo/regras.

### Model, formulário e esquema

| Campo | Firestore | Model/produção do formulário | Compatibilidade |
|---|---|---|---|
| nome | String | `String`, obrigatório, trim, limite 120 | Sim |
| categoria | String | `String`, obrigatório, texto livre, limite 120 | Sim; regra não limita a três categorias |
| cidade | String | `String`, seleção obrigatória | Sim; regra proposta limita às três cidades |
| avaliacao | Number | `double`, finito entre 0 e 5 | Sim; inteiro e decimal do Console são aceitos |
| distancia | Number | `double`, finito e não negativo | Sim; quilômetros |
| horario | String | `String`, até 120, pode ser vazio | Sim; chave continua obrigatória na regra |
| descricao | String | `String`, até 2000, pode ser vazio | Sim; chave continua obrigatória na regra |
| favorito | Boolean | `bool`; cadastro inicia `false` | Sim |

`Local.id` vem de `doc.id` e não entra em `toMap()`. O JSON didático inclui `id` apenas para definir o nome do documento: **não criar esse nono campo no Firestore**, pois a proposta rejeita campos extras.

O leitor do Model é tolerante: valores numéricos em texto podem ser convertidos, ausências viram valores padrão e avaliação/distância são limitadas. Isso evita algumas falhas de interface, mas pode esconder documentos malformados inseridos pelo administrador. O Console permite alterações administrativas fora das regras do cliente; manter os tipos corretos é necessário.

## 7. Problemas e pendências por prioridade

| Item | Situação atual | Problema identificado | Correção necessária | Responsável |
|---|---|---|---|---|
| P0 — Identidade remota | Project ID ausente | App sem projeto real selecionado | Conferir Console, reutilizar projeto existente ou criar um e registrar ID efetivo | USUÁRIO |
| P0 — App Android/Core | JSON/opções ausentes; bootstrap bloqueia | App não inicializa Firebase | Registrar pacote correto, executar fluxo local oficial e substituir bootstrap através do script existente; reconstruir | COMPARTILHADA |
| P0 — Banco | Estado remoto desconhecido | Serviço espera `(default)` | Criar/verificar Cloud Firestore padrão e região | USUÁRIO |
| P0 — Autenticação/autorização | Modal pronto; estado remoto desconhecido | Proposta exige usuário autenticado e allowlist | Ativar Email/Password, criar usuário da aplicação e `authorized_users/{UID}` | USUÁRIO |
| P0 — Regras | Arquivo padrão nega tudo | Deploy padrão não publica proposta; acesso pode falhar | Revisar/publicar proposta no Console, testar restrições; alinhar deploy local futuramente | COMPARTILHADA |
| P1 — Dados | Dez exemplos só em JSON local | Coleção real não comprovada | Cadastrar dez documentos com oito campos corretos | USUÁRIO |
| P1 — Prova de integração | Testes locais com substituto | UI/cache não comprovam servidor | Validar leitura servidor e CRUD no Console, reinício e Android | COMPARTILHADA |
| P1 — Dispositivo/memória | Android offline; memória livre muito baixa | Não há execução Android atual | Usuário liberar recursos ou usar celular; avaliar limites Gradle em etapa futura | COMPARTILHADA |
| P2 — Erro inicial descartado | `catch (_) {}` | Falha futura de config também será exibida genericamente | Preservar causa e diferenciar diagnóstico/configuração em futura correção | CODEX |
| P2 — Cidades divergentes | Interface aceita cidade vinda de documentos | Regra permite só São Paulo, Campinas, Jundiaí | Restringir dados às três agora; alinhar regra/UI se ampliar domínio | COMPARTILHADA |
| P2 — Concorrência de favorito | Edição grava mapa completo | Pode sobrescrever favorito alterado por outro usuário enquanto formulário está aberto | Atualizar só campos editáveis ou aplicar controle de concorrência | CODEX |
| P2 — Gravação offline | Formulário bloqueado enquanto aguarda write | Sem rede, confirmação pode permanecer pendente e cancelar fica desabilitado | Definir experiência offline/pending e recuperação sem sugerir que timeout cancela escrita | CODEX |
| P2 — Teste de autenticação | Integração espera `currentUser` já restaurado | Pode falhar antes da restauração da sessão; não realiza login | Validar sessão no dispositivo e sincronizar restauração se necessário | CODEX |
| P2 — Portabilidade | `.tooling_path.txt` absoluto fora do Desktop | Scripts dependem da cópia original | Documentar/preservar caminho ou tornar ferramentas portáveis em etapa futura | CODEX |
| P2 — Filtros do mapa | Categoria preservada ao mudar de aba | Filtro de categoria pode continuar ativo com controle oculto no mapa | Exibir filtros ativos ou limpar categoria na navegação | CODEX |
| P3 — Versionamento/publicação | Sem commits/remotes; assinatura release debug | Recuperação e distribuição release incompletas | Versionar e definir assinatura quando essas etapas forem autorizadas | COMPARTILHADA |

## 8. GUIA DE CONFIGURAÇÃO MANUAL DO FIREBASE

Os passos abaixo são instruções para uma etapa futura. **Nada deles foi executado nesta auditoria.** As etapas no Console são do usuário; o fluxo local também altera arquivos e deve ser realizado somente quando decidir configurar. Não recrie telas, serviço, modelo ou dependências que já existem.

### 8.1 Escolher o projeto e anotar a identidade real

1. Abra o [Firebase Console](https://console.firebase.google.com/) no navegador habitual e conclua login Google e eventual verificação diretamente nele. Não envie senha, códigos ou tokens pelo chat.
2. Verifique a lista de projetos. Se “Mapa de Locais” já foi criado, abra-o e confirme que é o projeto desejado. Caso contrário, escolha adicionar/criar projeto e use o nome de exibição **Mapa de Locais**.
3. Confira o Project ID que o Console propõe. A disponibilidade é global: não há um ID previamente conhecido ou reservado nesta auditoria. Anote o ID realmente aceito em Configurações do projeto → Geral.
4. Mantenha Google Analytics desativado se não precisar dele para a atividade e preserve o plano gratuito Spark. O app atual não usa Analytics. Não habilite faturamento como tentativa de corrigir login ou permissões.

O nome de exibição, o Project ID e o pacote Android são identificadores diferentes. Nos comandos adiante, substitua `SEU_PROJECT_ID_REAL` pelo ID copiado do Console; nunca use esse texto literalmente.

### 8.2 Registrar o Android e obter configuração

1. Em Configurações do projeto → Geral → Seus aplicativos, procure um Android já registrado com o pacote abaixo. Reutilize-o se estiver no projeto correto. Se não existir, clique no ícone Android/adicionar app.
2. Informe exatamente:

   ```text
   br.edu.mapa.mapa_locais
   ```

3. Use “Mapa de Locais Android” como apelido opcional. Para o Email/Password empregado aqui, SHA-1 não é requisito de entrada; provedores adicionais podem exigir configuração própria.
4. Registre o app. O pacote é sensível a maiúsculas/minúsculas e não pode ser mudado naquele registro depois. Baixe o `google-services.json` do app/projeto correto e, na etapa de configuração local, coloque-o sem sufixos `(1)` ou `(2)` em:

   ```text
   C:\Users\mathe\OneDrive\Área de Trabalho\mapa_locais\android\app\google-services.json
   ```

5. Confira `project_info.project_id` contra o ID selecionado e `client_info.android_client_info.package_name` contra o pacote acima. Arquivos de outro projeto não devem ser reutilizados. Esses identificadores não substituem regras/autenticação. O fluxo Android que processa JSON requer o plugin Google Services; a preparação Gradle deve ser conferida na etapa local, pois hoje o plugin está ausente. [Referência Android oficial](https://firebase.google.com/docs/android/setup).

### 8.3 Configurar FlutterFire e retirar o bloqueio de inicialização

A configuração oficial Flutter gera opções para a plataforma escolhida e exige inicialização antes de usar os plugins. [Referência Flutter oficial](https://firebase.google.com/docs/flutter/setup).

No terminal PowerShell do VS Code, na futura etapa autorizada:

```powershell
Set-Location -LiteralPath 'C:\Users\mathe\OneDrive\Área de Trabalho\mapa_locais'
.\scripts\login_firebase.ps1
.\scripts\configure_firebase.ps1 -ProjectId 'SEU_PROJECT_ID_REAL'
```

O login deve ser concluído por você no navegador oficial. O script de login recebe o código local com entrada oculta, quando solicitado; não envie esse código pelo chat. A autenticação da CLI é separada do usuário que entra no aplicativo.

O script de configuração já disponível chama:

```text
flutterfire configure --project=SEU_PROJECT_ID_REAL --platforms=android
```

Ele usa as ferramentas locais indicadas por `.tooling_path.txt`, verifica acesso da CLI e, após geração bem-sucedida de `lib/firebase_options.dart`, substitui o bootstrap por `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)`. **Executar apenas `flutterfire configure` diretamente não retira o bloqueio personalizado do bootstrap atual.** Nesse caminho alternativo, a inicialização deve ser ajustada em uma futura intervenção de código.

Se o CLI oferecer registrar app, selecione/reutilize o Android correto e confirme o pacote. Confira os arquivos Dart/nativos gerados e o Project ID; não instale novamente Firebase Core/Firestore/Auth já declarados. Não copie cegamente exemplos Gradle de outra versão. Depois disso será necessário recompilar: o APK existente continua sendo a versão anterior sem configuração.

Este projeto foi preparado para configurar Android. Rodar em Chrome ou Windows não substitui a configuração/teste Android; `--platforms=android` não gera opções para essas plataformas.

### 8.4 Habilitar Cloud Firestore e definir região

1. No projeto certo, abra Firestore Database/Firestore em Build ou Databases & Storage, conforme a interface do Console.
2. Se já existir o banco `(default)`, confira-o e preserve os dados. Não crie outro banco por suposição.
3. Se não existir, crie Cloud Firestore **Standard, em modo nativo**, com ID `(default)`. Não escolha Realtime Database nem compatibilidade MongoDB. O código atual usa o banco padrão.
4. Para as cidades desta atividade, **`southamerica-east1` (São Paulo)** é uma escolha razoável se disponível. Essa recomendação é inferida da proximidade dos usuários/dados; região altera latência, disponibilidade e preço. A localização de uma instância não pode ser alterada após sua criação; se o Console já a determinou por outro recurso, avalie antes de prosseguir. [Localizações oficiais](https://firebase.google.com/docs/firestore/locations).
5. Comece com regras restritivas/modo produção e depois publique as regras específicas do passo 8.7. Até lá, o bloqueio de clientes é esperado. Não deixe modo teste aberto como configuração final. [Criação do Firestore](https://firebase.google.com/docs/firestore/quickstart).

### 8.5 Ativar Authentication e autorizar a conta do app

1. Abra Authentication → começar → método de login/provedores.
2. Ative **E-mail/senha (Email/Password)**. É o provedor usado pelo código atual; habilitar só Google não atende ao modal existente. [Autenticação por senha em Flutter](https://firebase.google.com/docs/auth/flutter/password-auth).
3. Na aba usuários, adicione uma conta para o aplicativo e defina uma senha própria para ela. Um endereço Gmail pode ser usado, mas isso é uma identidade Email/Password da aplicação; **não é o login Google do Console e não exige reutilizar sua senha Google**.
4. Copie o UID dessa conta no Authentication.
5. Em Firestore → Dados, crie a coleção `authorized_users`, com um documento cujo ID seja exatamente o UID copiado. Pode inserir `observacao` do tipo String, com “Conta autorizada para atividade”. Esse campo é apenas informativo: a regra proposta verifica a existência do documento.
6. Não permita que o cliente crie sua própria autorização. Para revogar acesso nessa proposta, o administrador remove o documento de autorização; adicionar `ativo: false` não revoga nada.

O app não possui cadastro de usuários. A conta deve ser criada administrativamente. Após Core configurado, use o botão “Conta autorizada” no app para entrar com essa conta.

### 8.6 Criar `locais` com pelo menos dez registros

Em Firestore → Dados, escolha iniciar coleção `locais`. Insira um documento, depois adicione os outros nove. Use os IDs do JSON existente para facilitar conferência. Para cada documento, copie os oito campos de `data/locais_iniciais.json`, **excluindo `id` do conteúdo**:

| Campo | Tipo a escolher no Console | Exemplo do primeiro documento |
|---|---|---|
| nome | String | Academia Horizonte (exemplo) |
| categoria | String | Academia |
| cidade | String | São Paulo |
| avaliacao | Number | 4.8 |
| distancia | Number | 1.2 |
| horario | String | 06:00 - 22:00 |
| descricao | String | Registro didático fictício: musculação e aulas coletivas. |
| favorito | Boolean | false |

Não coloque números ou booleanos entre aspas. Use exatamente os nomes das chaves, acentos das cidades e tipo Number para avaliação/distância. Horário e descrição podem ser strings vazias, mas as chaves devem existir. Avaliação entre 0 e 5; distância não negativa. Os exemplos são fictícios, sem comprovação de endereço, avaliação ou atendimento real.

| ID do documento | Nome | Categoria | Cidade | Avaliação | Distância km |
|---|---|---|---|---|---|
| exemplo-sp-01 | Academia Horizonte (exemplo) | Academia | São Paulo | 4.8 | 1.2 |
| exemplo-sp-02 | Restaurante Jardim (exemplo) | Restaurante | São Paulo | 4.5 | 2.4 |
| exemplo-sp-03 | Hospital Central (exemplo) | Hospital | São Paulo | 4.3 | 3.1 |
| exemplo-sp-04 | Academia Movimento (exemplo) | Academia | São Paulo | 4.0 | 4.7 |
| exemplo-sp-05 | Restaurante Sabores (exemplo) | Restaurante | São Paulo | 4.2 | 5.2 |
| exemplo-cp-01 | Academia Energia (exemplo) | Academia | Campinas | 4.7 | 1.4 |
| exemplo-cp-02 | Restaurante Estação (exemplo) | Restaurante | Campinas | 4.6 | 2.0 |
| exemplo-cp-03 | Hospital Vida (exemplo) | Hospital | Campinas | 4.4 | 3.5 |
| exemplo-ju-01 | Academia Parque (exemplo) | Academia | Jundiaí | 4.9 | 1.8 |
| exemplo-ju-02 | Restaurante Serra (exemplo) | Restaurante | Jundiaí | 4.3 | 2.7 |

Para completar todos os documentos, copie também `horario`, `descricao` e `favorito: false` do JSON, além das cinco colunas de dados acima. São cinco locais em São Paulo, três em Campinas e dois em Jundiaí: a tela inicial de São Paulo pode mostrar cinco marcadores quando não houver filtros adicionais.

O Console não importa esse JSON pelo simples ato de colocá-lo no projeto. O script `seed.cjs` é alternativa administrativa existente, mas exige credenciais ADC/Admin SDK, Project ID e flag `--approve-remote-seed`; login da Firebase CLI sozinho não fornece essas credenciais. O script evita sobrescrever IDs existentes e rejeita emulador Firestore. Para esta configuração manual, inserir pelo Console é o caminho que não requer preparar credenciais administrativas adicionais.

### 8.7 Publicar regras restritas e testar

1. Abra o arquivo local `firestore.proposed.rules` e revise a proposta já existente, que é compatível com os oito campos e três cidades desta atividade.
2. No Console → Firestore → Regras, copie **todo esse arquivo** para o editor, confirme o projeto/banco e publique quando decidir aplicar essa política. Não copie `firestore.rules`: ele é a versão de bloqueio total.
3. A regra autoriza somente `request.auth != null` com existência de `authorized_users/{UID}`. Criação/edição também passam por validação de campos, tipos, limites e cidades. O cliente não ganha acesso direto à coleção de autorização. Regras com `exists()` e autenticação são mecanismos documentados oficialmente. [Condições de regras](https://firebase.google.com/docs/firestore/security/rules-conditions).
4. No simulador de regras, confira: não autenticado → negado; UID sem autorização → negado; UID autorizado, documento válido → permitido; avaliação acima de 5, número como texto, campo extra ou cidade fora das três → criação/edição negada. Use o documento de autorização previamente criado no banco para os testes de existência.
5. Confirme que leitura e exclusão de `locais` são permitidas ao UID autorizado. Exclusão não valida os campos do documento removido; a autorização continua obrigatória.

Não publique `allow read, write: if true` como resultado final. O bloqueio genérico ao fim da proposta não cancela as permissões específicas válidas de `locais`, pois matches de regras são combinados por permissão. Depois de publicar manualmente, a configuração local de deploy ainda aponta ao deny-all: alinhar isso é pendência de código futura, antes de usar deploy via CLI.

### 8.8 Autenticação, aprovação e custos

Login Google/CLI exige sua autenticação pessoal e consentimento. Criar projeto, escolher região, criar usuários/documentos, publicar regras e usar carga administrativa são operações reais que você executará deliberadamente; não foram realizadas por esta auditoria. A escolha de região deve ser revisada antes da criação pela impossibilidade de mudança direta posterior.

O Firestore possui quota gratuita para um banco por projeto: 1 GiB armazenado, 50.000 leituras/dia, 20.000 escritas/dia e 20.000 exclusões/dia; consumo adicional exige avaliar faturamento. Listeners e verificações de regras podem consumir leituras. A atividade pequena pode começar no Spark, acompanhando Uso no Console. Não ative Blaze, recursos pagos, backups/PITR/TTL ou serviços adicionais sem decidir sobre os custos. [Quotas oficiais](https://firebase.google.com/docs/firestore/quotas).

Não há necessidade demonstrada de Storage, Cloud Functions, SMS ou API de mapas para o código atual. Permissão de administrador do Console/credenciais Admin SDK é distinta das regras do cliente e pode acessar dados fora delas. Nunca coloque chave de service account em assets, código Flutter ou APK.

### 8.9 Comprovar conexão real e persistência

Depois das configurações e recompilação, com Android online e memória disponível:

1. Execute o app Android e entre pelo modal com a conta Email/Password autorizada. Confirme que a tela de configuração desapareceu.
2. Verifique os dez documentos no Console e os resultados por cidade no app. Uma lista visível sozinha pode vir do cache: não encerra a comprovação.
3. Crie pelo app um local com nome identificável, por exemplo “Teste de integração 12-10”. No Console, confirme novo documento, os oito campos e os tipos.
4. Edite nome/horário e confirme os novos valores no Console; marque/desmarque favorito e confira o booleano no documento.
5. Feche e reabra o app; confirme que o cadastro continua disponível e também permanece no servidor.
6. Exclua o registro de teste com confirmação e confira a remoção no Console e na interface. Não use os exemplos que precisam permanecer para a entrega.
7. Altere um nome de exemplo no Console com o app aberto; observe atualização pelo stream sem reiniciar e depois restaure o texto deliberadamente.
8. Valide restrições: usuário sem autorização não acessa dados; autorizado usa o app. Ao sair, não interprete eventual conteúdo local anterior como autorização de leitura remota.

Teste de integração de leitura já preparado, para futura execução:

```text
flutter test integration_test/firestore_connection_test.dart -d ID_DO_ANDROID
```

Esse teste faz `get(Source.server)` com limite de 20 segundos antes de conferir o stream. Ele pressupõe sessão autenticada no mesmo aplicativo/dispositivo; não cria usuário nem faz login. A restauração da sessão deve ser conferida, pois `currentUser` pode ainda não estar disponível no instante inicial. Não envie credenciais na linha de comando. Esse teste não substitui a verificação manual de cadastro/edição/exclusão/favorito e persistência após reinício.

Anote Project ID real, UID de teste, dispositivo, resultados e capturas reais. O APK atual sem Firebase e as prévias rotuladas com dados simulados não são provas do backend.

## 9. Testes e evidências disponíveis

`docs/TESTES.md` registra onze testes locais aprovados no último conjunto completo, teste T05 direcionado posterior aprovado, análise sem erros pela execução compatível com o caminho e builds debug bem-sucedidos, inclusive incremental em 27,8 segundos. Os arquivos de teste estão presentes e foram inspecionados; **nenhuma execução foi repetida nesta auditoria**.

Esses testes exercitam modelo, filtros, navegação, validações, edição, exclusão, favorito e tratamento de erro com repositório substituto. Não validam permissões remotas, credenciais ou rede real. T01 (leitura real) e T06 (persistência após reinício) permanecem sem comprovação. O teste de prévia pode gravar capturas, motivo adicional para não executá-lo no escopo somente diagnóstico.

## 10. Checklist de prontidão

| Item | Estado | Justificativa |
|---|---|---|
| Projeto Flutter localizado | CONCLUÍDO | Pasta Desktop/OneDrive e pubspec confirmados |
| Ambiente Flutter validado | CONCLUÍDO | Versões e doctor consultados; disponibilidade Android executável é pendência separada |
| Projeto Firebase identificado | PENDENTE | Nenhum Project ID real na configuração local; confirmar no Console |
| Aplicativo Android registrado | NÃO VERIFICADO | Ausência de config local não prova estado remoto |
| Firebase Core configurado | PENDENTE | Bootstrap lança erro e opções não existem |
| Cloud Firestore habilitado | NÃO VERIFICADO | Console não consultado remotamente |
| Coleção `locais` disponível | NÃO VERIFICADO | Nome presente no código; documentos remotos não comprovados |
| Leitura real comprovada | PENDENTE | Sem execução servidor bem-sucedida |
| Cadastro funcionando | PENDENTE | Código pronto; gravação real não demonstrada |
| Edição funcionando | PENDENTE | Código pronto; alteração real não demonstrada |
| Exclusão funcionando | PENDENTE | Código pronto; remoção real não demonstrada |
| Favoritos funcionando | PENDENTE | Código pronto; persistência real não demonstrada |
| Três telas implementadas | CONCLUÍDO | Código/interface presentes; execução Android ainda não verificada |
| Compilação Android validada | CONCLUÍDO | Evidência histórica debug e APK/hash atual conferidos; novo build após Firebase pendente |

## 11. Próximas ações em ordem de execução

1. **USUÁRIO:** conferir/criar projeto no Console e anotar Project ID real.
2. **USUÁRIO:** registrar/reutilizar Android com `br.edu.mapa.mapa_locais` e obter JSON correspondente.
3. **USUÁRIO:** conferir/criar Firestore `(default)`, revisar região, habilitar Email/Password e criar conta autorizada.
4. **USUÁRIO:** cadastrar `authorized_users/{UID}` e dez documentos válidos em `locais`; revisar, publicar e simular a proposta restrita.
5. **COMPARTILHADA:** em etapa de configuração, concluir CLI login e executar o script FlutterFire existente, verificando opções, pacote e bootstrap; alinhar configuração de deploy de regras.
6. **COMPARTILHADA:** obter Android online com memória suficiente, recompilar e demonstrar leitura real/CRUD/reinício no servidor.
7. **CODEX, em futura etapa autorizada:** tratar diagnóstico inicial, concorrência, experiência offline, alinhamento de cidades/filtros e portabilidade conforme tabela; não são correções realizadas neste relatório.
8. **COMPARTILHADA:** registrar evidências finais e versionar o projeto. Preservar os componentes já desenvolvidos.

**Conclusão:** implementação local preparada, configuração Firebase pendente e integração Android/servidor ainda sem comprovação. Este relatório não cria projeto remoto, não publica regras e não modifica o código existente.
