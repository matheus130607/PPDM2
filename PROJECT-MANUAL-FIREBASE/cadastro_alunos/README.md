# Cadastro de Alunos

## Objetivo

Projeto Flutter com um CRUD de alunos preparado para integracao posterior com Firebase Cloud Firestore.

O aplicativo funciona imediatamente usando dados temporarios em memoria. A integracao externa com Firebase ainda deve ser realizada manualmente.

## Funcionalidades

- Cadastro
- Listagem
- Edicao
- Exclusao
- Confirmacao antes da exclusao
- Validacao
- Pesquisa
- Contador
- Responsividade
- Repositorio em memoria
- Estrutura preparada para Firestore

## Estrutura do aluno

```text
nome
idade
curso
email
```

## Organizacao

```text
lib/
  main.dart
  models/
    aluno.dart
  repositories/
    aluno_repository.dart
    memory_aluno_repository.dart
    firestore_aluno_repository.dart
  screens/
    alunos_page.dart
  widgets/
    aluno_card.dart
    aluno_form.dart
```

## Firebase

A integracao externa com Firebase ainda deve ser realizada manualmente.

Pendencias:

- criar projeto no Firebase Console;
- registrar aplicativo Android;
- conferir o `applicationId`;
- baixar `google-services.json`;
- colocar em `android/app/`;
- configurar Firebase conforme documentacao atual;
- criar Firestore;
- criar colecao `alunos`;
- definir regras de seguranca;
- ativar inicializacao do Firebase no Flutter;
- alterar `useFirebase` para `true` quando tudo estiver configurado;
- testar Create, Read, Update e Delete no banco real.

Nao ha credenciais falsas ou configuracoes inventadas no projeto.
