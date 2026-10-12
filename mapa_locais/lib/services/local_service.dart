import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/local.dart';

abstract interface class LocalRepository {
  Stream<List<Local>> listarLocais();
  Future<void> adicionar(Local local);
  Future<void> atualizar(Local local);
  Future<void> excluir(String id);
  Future<void> alterarFavorito(String id, bool favorito);
}

class LocalService implements LocalRepository {
  LocalService({FirebaseFirestore? firestore})
    : _collection = (firestore ?? FirebaseFirestore.instance).collection(
        'locais',
      );
  final CollectionReference<Map<String, dynamic>> _collection;
  @override
  Stream<List<Local>> listarLocais() => _collection.snapshots().map((snapshot) {
    final locais = snapshot.docs
        .map((doc) => Local.fromMap(doc.id, doc.data()))
        .toList();
    locais.sort((a, b) => a.nome.compareTo(b.nome));
    return locais;
  });
  @override
  Future<void> adicionar(Local local) async {
    await _collection.add(local.toMap());
  }

  @override
  Future<void> atualizar(Local local) =>
      _collection.doc(local.id).update(local.toMap());
  @override
  Future<void> excluir(String id) => _collection.doc(id).delete();
  @override
  Future<void> alterarFavorito(String id, bool favorito) =>
      _collection.doc(id).update({'favorito': favorito});
}
