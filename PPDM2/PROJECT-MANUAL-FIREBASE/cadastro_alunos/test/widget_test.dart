import 'package:cadastro_alunos/main.dart';
import 'package:cadastro_alunos/repositories/memory_aluno_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CRUD local de alunos com validacao, pesquisa e contador', (
    WidgetTester tester,
  ) async {
    final repository = MemoryAlunoRepository(comDadosDeExemplo: false);
    await tester.pumpWidget(CadastroAlunosApp(repository: repository));
    await tester.pumpAndSettle();

    expect(find.text('Nenhum aluno cadastrado.'), findsOneWidget);
    expect(find.text('Total de alunos: 0'), findsOneWidget);

    await tester.tap(find.text('Novo aluno'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cadastrar'));
    await tester.pumpAndSettle();

    expect(find.text('Preencha o nome do aluno.'), findsOneWidget);
    expect(find.text('Informe uma idade valida.'), findsOneWidget);
    expect(find.text('Preencha o curso.'), findsOneWidget);
    expect(find.text('Informe um e-mail valido.'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'Joao');
    await tester.enterText(find.byType(TextFormField).at(1), '18');
    await tester.enterText(
      find.byType(TextFormField).at(2),
      'Desenvolvimento de Sistemas',
    );
    await tester.enterText(find.byType(TextFormField).at(3), 'joao@email.com');
    await tester.tap(find.text('Cadastrar'));
    await tester.pumpAndSettle();

    expect(find.text('Joao'), findsOneWidget);
    expect(find.text('18 anos'), findsOneWidget);
    expect(find.text('Total de alunos: 1'), findsOneWidget);

    await tester.tap(find.byTooltip('Editar'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(1), '19');
    await tester.tap(find.text('Salvar alteracoes'));
    await tester.pumpAndSettle();

    expect(find.text('19 anos'), findsOneWidget);
    expect(find.text('Total de alunos: 1'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Joao');
    await tester.pumpAndSettle();
    expect(find.text('Total de alunos: 1 - encontrados: 1'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Maria');
    await tester.pumpAndSettle();
    expect(find.text('Nenhum aluno encontrado.'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '');
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Excluir'));
    await tester.pumpAndSettle();
    expect(find.text('Excluir aluno?'), findsOneWidget);

    await tester.tap(find.text('Excluir'));
    await tester.pumpAndSettle();

    expect(find.text('Nenhum aluno cadastrado.'), findsOneWidget);
    expect(find.text('Total de alunos: 0'), findsOneWidget);
  });
}
