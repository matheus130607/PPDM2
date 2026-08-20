import '../models/aluno.dart';

abstract class AlunoRepository {
  Stream<List<Aluno>> observarAlunos();

  Future<void> cadastrarAluno(Aluno aluno);

  Future<void> atualizarAluno(Aluno aluno);

  Future<void> excluirAluno(String id);

  void dispose() {}
}
