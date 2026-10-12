import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapa_locais/app.dart';
import 'package:mapa_locais/models/local.dart';
import 'package:mapa_locais/widgets/local_form.dart';

import 'support/test_repository.dart';

Local sample() => Local.fromMap('a', {
  'nome': 'Academia Teste',
  'categoria': 'Academia',
  'cidade': 'São Paulo',
  'avaliacao': 4.8,
  'distancia': 1.2,
  'horario': '06:00–22:00',
  'descricao': 'Descrição de teste',
});
Future<void> results(WidgetTester t) async {
  await t.tap(find.text('Resultados').last);
  await t.pumpAndSettle();
}

void main() {
  testWidgets('Missing configuration is explicit, no fake places', (t) async {
    await t.pumpWidget(const MapaLocaisApp());
    expect(find.text('Conecte seu Firebase'), findsOneWidget);
    expect(find.text('Academia Teste'), findsNothing);
  });
  testWidgets('T10 details/back/map and T09 realtime favorite', (t) async {
    final r = TestRepository([sample()]);
    addTearDown(r.dispose);
    await t.pumpWidget(MapaLocaisApp(repository: r));
    await t.pumpAndSettle();
    await results(t);
    await t.tap(find.text('Academia Teste'));
    await t.pumpAndSettle();
    expect(find.text('Descrição de teste'), findsOneWidget);
    await t.ensureVisible(find.text('Marcar favorito'));
    await t.tap(find.text('Marcar favorito'));
    await t.pumpAndSettle();
    expect(r.locals.single.favorito, true);
    expect(find.text('Remover favorito'), findsOneWidget);
    await t.tap(find.text('Remover favorito'));
    await t.pumpAndSettle();
    expect(r.locals.single.favorito, false);
    ScaffoldMessenger.of(t.element(find.byType(OutlinedButton)))
        .clearSnackBars();
    await t.pumpAndSettle();
    await t.ensureVisible(find.widgetWithText(OutlinedButton, 'Ver no mapa'));
    await t.tap(find.widgetWithText(OutlinedButton, 'Ver no mapa'));
    await t.pumpAndSettle();
    expect(find.text('Explore os locais'), findsOneWidget);
    await results(t);
    await t.tap(find.text('Academia Teste'));
    await t.pumpAndSettle();
    await t.tap(find.text('Voltar'));
    await t.pumpAndSettle();
    expect(find.text('Editar'), findsOneWidget);
  });
  testWidgets(
    'T08 deletion cancellation preserves data, confirmation removes',
    (t) async {
      final r = TestRepository([sample()]);
      addTearDown(r.dispose);
      await t.pumpWidget(MapaLocaisApp(repository: r));
      await t.pumpAndSettle();
      await results(t);
      await t.tap(find.text('Excluir'));
      await t.pumpAndSettle();
      await t.tap(find.text('Cancelar'));
      await t.pumpAndSettle();
      expect(r.deletes, 0);
      await t.tap(find.text('Excluir'));
      await t.pumpAndSettle();
      await t.tap(find.widgetWithText(FilledButton, 'Excluir'));
      await t.pumpAndSettle();
      expect(r.deletes, 1);
      expect(r.locals, isEmpty);
      expect(find.textContaining('Nenhum local encontrado'), findsOneWidget);
    },
  );
  testWidgets('T11 empty and stream failure have understandable states', (
    t,
  ) async {
    final r = TestRepository();
    addTearDown(r.dispose);
    await t.pumpWidget(MapaLocaisApp(repository: r));
    await t.pumpAndSettle();
    await results(t);
    expect(find.textContaining('Nenhum local encontrado'), findsOneWidget);
    r.controller.addError(StateError('test error'));
    await t.pumpAndSettle();
    expect(find.text('Tentar novamente'), findsOneWidget);
  });
  testWidgets('T05 form validates values and blocks repeated save', (t) async {
    final r = TestRepository();
    addTearDown(r.dispose);
    r.saveGate = Completer<void>();
    await t.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LocalForm(repository: r, cidade: 'São Paulo'),
        ),
      ),
    );
    await t.ensureVisible(find.text('Salvar no Firestore'));
    await t.tap(find.text('Salvar no Firestore'));
    await t.pumpAndSettle();
    expect(find.text('Campo obrigatório'), findsNWidgets(2));
    expect(r.creates, 0);
    final fields = find.byType(TextFormField);
    await t.enterText(fields.at(0), 'Novo local');
    await t.enterText(fields.at(1), 'Academia');
    await t.enterText(fields.at(2), '6');
    await t.enterText(fields.at(3), '-1');
    await t.ensureVisible(find.text('Salvar no Firestore'));
    await t.tap(find.text('Salvar no Firestore'));
    await t.pumpAndSettle();
    expect(find.text('Informe um número de 0 a 5'), findsOneWidget);
    expect(find.text('Informe uma distância não negativa'), findsOneWidget);
    expect(r.creates, 0);
    await t.enterText(fields.at(2), '4,8');
    await t.enterText(fields.at(3), '1,2');
    await t.ensureVisible(find.text('Salvar no Firestore'));
    await t.tap(find.text('Salvar no Firestore'));
    await t.pump();
    expect(r.creates, 1);
    expect(find.widgetWithText(FilledButton, 'Salvando…'), findsOneWidget);
    await t.tap(find.text('Salvando…'));
    await t.pump();
    expect(r.creates, 1);
    r.saveGate!.complete();
    await t.pumpAndSettle();
    expect(r.locals.single.avaliacao, 4.8);
  });
  testWidgets('T07 edit preserves ID and favorite', (t) async {
    final r = TestRepository([sample()]);
    addTearDown(r.dispose);
    await t.pumpWidget(MapaLocaisApp(repository: r));
    await t.pumpAndSettle();
    await results(t);
    await t.tap(find.text('Editar'));
    await t.pumpAndSettle();
    await t.enterText(find.byType(TextFormField).first, 'Academia Editada');
    await t.ensureVisible(find.text('Salvar no Firestore'));
    await t.tap(find.text('Salvar no Firestore'));
    await t.pumpAndSettle();
    expect(r.updates, 1);
    expect(r.locals.single.id, 'a');
    expect(find.text('Academia Editada'), findsOneWidget);
  });
  testWidgets('T11 write errors retain form and allow retry', (t) async {
    final r = TestRepository()..failWrites = true;
    addTearDown(r.dispose);
    await t.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LocalForm(repository: r, cidade: 'São Paulo'),
        ),
      ),
    );
    await t.enterText(find.byType(TextFormField).at(0), 'Nome');
    await t.enterText(find.byType(TextFormField).at(1), 'Categoria');
    await t.ensureVisible(find.text('Salvar no Firestore'));
    await t.tap(find.text('Salvar no Firestore'));
    await t.pumpAndSettle();
    expect(
      find.text('Não foi possível concluir a operação. Tente novamente.'),
      findsOneWidget,
    );
    expect(
      find.widgetWithText(FilledButton, 'Salvar no Firestore'),
      findsOneWidget,
    );
    expect(r.locals, isEmpty);
  });
}
