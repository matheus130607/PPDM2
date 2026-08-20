import 'dart:async';

import '../models/aluno.dart';
import 'aluno_repository.dart';

class MemoryAlunoRepository implements AlunoRepository {
  MemoryAlunoRepository({bool comDadosDeExemplo = true}) {
    if (comDadosDeExemplo) {
      _alunos.addAll(const [
        Aluno(
          id: 'exemplo-1',
          nome: 'Joao Silva',
          idade: 18,
          curso: 'Desenvolvimento de Sistemas',
          email: 'joao@email.com',
        ),
        Aluno(
          id: 'exemplo-2',
          nome: 'Maria Souza',
          idade: 17,
          curso: 'Informatica',
          email: 'maria@email.com',
        ),
      ]);
    }
  }

  final List<Aluno> _alunos = [];
  final StreamController<List<Aluno>> _controller =
      StreamController<List<Aluno>>.broadcast();

  @override
  Stream<List<Aluno>> observarAlunos() async* {
    yield List.unmodifiable(_alunos);
    yield* _controller.stream;
  }

  @override
  Future<void> cadastrarAluno(Aluno aluno) async {
    final alunoComId = aluno.id.isEmpty
        ? aluno.copyWith(id: DateTime.now().microsecondsSinceEpoch.toString())
        : aluno;
    _alunos.add(alunoComId);
    _emitirAtualizacao();
  }

  @override
  Future<void> atualizarAluno(Aluno aluno) async {
    final index = _alunos.indexWhere((item) => item.id == aluno.id);
    if (index == -1) {
      throw Exception('Aluno nao encontrado para edicao.');
    }

    _alunos[index] = aluno;
    _emitirAtualizacao();
  }

  @override
  Future<void> excluirAluno(String id) async {
    _alunos.removeWhere((aluno) => aluno.id == id);
    _emitirAtualizacao();
  }

  void _emitirAtualizacao() {
    if (!_controller.isClosed) {
      _controller.add(List.unmodifiable(_alunos));
    }
  }

  @override
  void dispose() {
    _controller.close();
  }
}
