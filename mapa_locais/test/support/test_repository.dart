import 'dart:async';

import 'package:mapa_locais/models/local.dart';
import 'package:mapa_locais/services/local_service.dart';

// In-memory data exists only in automated tests, never in the application.
class TestRepository implements LocalRepository {
  TestRepository([List<Local>? initial]) : locals = initial ?? [];
  List<Local> locals;
  final controller = StreamController<List<Local>>.broadcast();
  int creates = 0, updates = 0, deletes = 0;
  bool failWrites = false;
  Completer<void>? saveGate;
  @override
  Stream<List<Local>> listarLocais() async* {
    yield List.of(locals);
    yield* controller.stream;
  }

  void emit() => controller.add(List.of(locals));
  @override
  Future<void> adicionar(Local l) async {
    creates++;
    if (saveGate != null) {
      await saveGate!.future;
    }
    if (failWrites) {
      throw StateError('test failure');
    }
    locals.add(Local.fromMap('new-$creates', l.toMap()));
    emit();
  }

  @override
  Future<void> atualizar(Local l) async {
    updates++;
    locals = locals.map((v) => v.id == l.id ? l : v).toList();
    emit();
  }

  @override
  Future<void> excluir(String id) async {
    deletes++;
    locals.removeWhere((l) => l.id == id);
    emit();
  }

  @override
  Future<void> alterarFavorito(String id, bool favorito) async {
    locals = locals
        .map(
          (l) => l.id == id
              ? Local.fromMap(id, {...l.toMap(), 'favorito': favorito})
              : l,
        )
        .toList();
    emit();
  }

  Future<void> dispose() => controller.close();
}
