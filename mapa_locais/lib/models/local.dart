class Local {
  const Local({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.cidade,
    required this.avaliacao,
    required this.distancia,
    required this.horario,
    required this.descricao,
    this.favorito = false,
  });
  final String id, nome, categoria, cidade, horario, descricao;
  final double avaliacao, distancia;
  final bool favorito;
  static double number(Object? value) {
    final result = value is num
        ? value.toDouble()
        : double.tryParse('$value'.replaceAll(',', '.'));
    return result != null && result.isFinite ? result : 0;
  }

  factory Local.fromMap(String id, Map<String, dynamic> data) => Local(
    id: id,
    nome: data['nome'] is String ? data['nome'] as String : '',
    categoria: data['categoria'] is String ? data['categoria'] as String : '',
    cidade: data['cidade'] is String ? data['cidade'] as String : '',
    avaliacao: number(data['avaliacao']).clamp(0, 5),
    distancia: number(data['distancia']).clamp(0, double.maxFinite),
    horario: data['horario'] is String ? data['horario'] as String : '',
    descricao: data['descricao'] is String ? data['descricao'] as String : '',
    favorito: data['favorito'] == true,
  );
  Map<String, dynamic> toMap() => {
    'nome': nome,
    'categoria': categoria,
    'cidade': cidade,
    'avaliacao': avaliacao,
    'distancia': distancia,
    'horario': horario,
    'descricao': descricao,
    'favorito': favorito,
  };
}
