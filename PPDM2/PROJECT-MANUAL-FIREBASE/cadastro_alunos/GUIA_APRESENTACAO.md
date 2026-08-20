# Guia de Apresentacao

## O que e o Firebase?

Firebase e uma plataforma de backend usada pelo aplicativo para armazenamento de dados e outros servicos.

## Para que serve `firebase_core`?

O pacote `firebase_core` faz a inicializacao base do Firebase no Flutter. Ele precisa ser configurado antes de outros servicos Firebase serem usados.

## Para que serve `cloud_firestore`?

O pacote `cloud_firestore` permite que o Flutter leia, cadastre, edite e exclua dados no Cloud Firestore.

## O que e uma colecao?

Uma colecao e um agrupamento de documentos. Neste projeto, a colecao preparada se chama:

```text
alunos
```

## O que e um documento?

Um documento e um registro individual dentro da colecao. Neste projeto, cada documento representa um aluno.

## Metodos preparados

Insercao:

```dart
add()
```

Atualizacao:

```dart
update()
```

Exclusao:

```dart
delete()
```

Atualizacao em tempo real:

```dart
collection('alunos').snapshots()
```

## `setState()` x Firestore

`setState()` altera o estado visual/local da interface e pede para o Flutter reconstruir a tela.

Firestore e responsavel por persistir os dados no banco remoto. Depois da integracao real, os dados permanecem salvos porque estarao no Firestore, e nao apenas na memoria da aplicacao.

## Fluxo do cadastro

```text
Usuario
   ↓
preenche formulario
   ↓
Flutter valida os campos
   ↓
Repository
   ↓
Firestore
   ↓
colecao alunos
   ↓
documento salvo
   ↓
Stream recebe alteracao
   ↓
interface atualiza
```

Quando o usuario clica em Cadastrar, o Flutter le os campos, remove espacos extras com `trim()` e valida nome, idade, curso e e-mail. Se algum campo estiver invalido, a interface mostra uma mensagem clara e o cadastro nao continua.

Se os dados estiverem corretos, a tela cria um objeto `Aluno` e envia para o `AlunoRepository`. No modo atual, o `MemoryAlunoRepository` salva temporariamente em memoria. Depois da configuracao manual do Firebase, o `FirestoreAlunoRepository` podera enviar os dados para a colecao `alunos` usando `add()`.

Com Firestore ativo, a tela podera receber as alteracoes por `snapshots()`. Assim, quando o banco mudar, o stream emite uma nova lista e a interface e reconstruida automaticamente.

## Proximos Passos - Firebase

1. Criar o projeto no Firebase Console.
2. Adicionar aplicativo Android.
3. Copiar o `applicationId` real do projeto.
4. Registrar esse pacote no Firebase.
5. Baixar `google-services.json`.
6. Colocar em:

```text
android/app/google-services.json
```

7. Fazer as configuracoes Android recomendadas pela documentacao atual do Firebase.
8. Criar o Cloud Firestore.
9. Criar/configurar a colecao `alunos`.
10. Definir regras adequadas.
11. Configurar Firebase para outras plataformas caso necessario.
12. Ativar a inicializacao Firebase no codigo.
13. Trocar o repositorio em memoria pelo Firestore.
14. Testar Create, Read, Update e Delete no banco real.
