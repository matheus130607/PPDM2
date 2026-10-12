import 'package:flutter_test/flutter_test.dart';
import 'package:mapa_locais/models/local.dart';
import 'package:mapa_locais/utils/filters.dart';

void main() {
  test('Model: numbers, missing and malformed fields are safe', () {
    final l = Local.fromMap('id', {
      'nome': 3,
      'avaliacao': '4,8',
      'distancia': 2,
      'favorito': 'true',
    });
    expect(l.id, 'id');
    expect(l.nome, '');
    expect(l.avaliacao, 4.8);
    expect(l.distancia, 2);
    expect(l.favorito, false);
    expect(Local.number(double.nan), 0);
    expect(Local.number(double.infinity), 0);
    expect(Local.fromMap('x', {'avaliacao': 8, 'distancia': -4}).avaliacao, 5);
    expect(Local.fromMap('x', {'distancia': -4}).distancia, 0);
  });
  test(
    'Model roundtrip includes all eight fields and keeps document ID external',
    () {
      final l = Local.fromMap('x', {
        'nome': 'A',
        'categoria': 'Academia',
        'cidade': 'São Paulo',
        'avaliacao': 4,
        'distancia': 1,
        'horario': '06–22',
        'descricao': 'Teste',
        'favorito': true,
      });
      expect(l.toMap().length, 8);
      expect(l.toMap().containsKey('id'), false);
      expect(Local.fromMap(l.id, l.toMap()).toMap(), l.toMap());
    },
  );
  test(
    'T02/T03/T04/T09 filters combine city, name/category, accents and favorite',
    () {
      final locals = [
        Local.fromMap('1', {
          'nome': 'Saúde',
          'categoria': 'Academia',
          'cidade': 'Campinas',
          'favorito': true,
        }),
        Local.fromMap('2', {
          'nome': 'B',
          'categoria': 'Hospital',
          'cidade': 'Campinas',
        }),
        Local.fromMap('3', {
          'nome': 'C',
          'categoria': 'Academia',
          'cidade': 'São Paulo',
        }),
      ];
      expect(
        filtrar(locals, cidade: 'Campinas', busca: 'ACADEMIA').single.id,
        '1',
      );
      expect(filtrar(locals, cidade: 'Campinas').length, 2);
      expect(
        filtrar(locals, cidade: 'Campinas', categoria: 'Hospital').single.id,
        '2',
      );
      expect(
        filtrar(
          locals,
          cidade: 'Campinas',
          busca: 'saude',
          favoritos: true,
        ).single.id,
        '1',
      );
      expect(filtrar(locals, cidade: 'Jundiaí'), isEmpty);
    },
  );
}
