class Aluno {
  const Aluno({
    required this.id,
    required this.nome,
    required this.idade,
    required this.curso,
    required this.email,
  });

  final String id;
  final String nome;
  final int idade;
  final String curso;
  final String email;

  factory Aluno.fromMap(String id, Map<String, dynamic> map) {
    return Aluno(
      id: id,
      nome: map['nome'] as String? ?? '',
      idade: (map['idade'] as num?)?.toInt() ?? 0,
      curso: map['curso'] as String? ?? '',
      email: map['email'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'nome': nome, 'idade': idade, 'curso': curso, 'email': email};
  }

  Aluno copyWith({
    String? id,
    String? nome,
    int? idade,
    String? curso,
    String? email,
  }) {
    return Aluno(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      idade: idade ?? this.idade,
      curso: curso ?? this.curso,
      email: email ?? this.email,
    );
  }
}
