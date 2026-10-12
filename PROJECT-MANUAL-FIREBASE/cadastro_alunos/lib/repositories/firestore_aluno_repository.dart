import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/aluno.dart';
import 'aluno_repository.dart';

class FirestoreAlunoRepository implements AlunoRepository {
  FirestoreAlunoRepository({FirebaseFirestore? firestore})
    : _alunosCollection = (firestore ?? FirebaseFirestore.instance).collection(
        'alunos',
      );

  final CollectionReference<Map<String, dynamic>> _alunosCollection;

  @override
  Stream<List<Aluno>> observarAlunos() {
    return _alunosCollection
        .orderBy('nome')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Aluno.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  @override
  Future<void> cadastrarAluno(Aluno aluno) async {
    await _alunosCollection.add(aluno.toMap());
  }

  @override
  Future<void> atualizarAluno(Aluno aluno) async {
    await _alunosCollection.doc(aluno.id).update(aluno.toMap());
  }

  @override
  Future<void> excluirAluno(String id) async {
    await _alunosCollection.doc(id).delete();
  }

  @override
  void dispose() {}
}
