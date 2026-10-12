import '../models/local.dart';

const cidades = ['São Paulo', 'Campinas', 'Jundiaí'];
const categorias = ['Academia', 'Restaurante', 'Hospital'];
String normalize(String value) {
  var text = value.toLowerCase().trim();
  const accents = 'áàâãäéèêëíìîïóòôõöúùûüç';
  const plain = 'aaaaaeeeeiiiiooooouuuuc';
  for (var i = 0; i < accents.length; i++) {
    text = text.replaceAll(accents[i], plain[i]);
  }
  return text;
}

List<Local> filtrar(
  List<Local> locais, {
  required String cidade,
  String categoria = 'Todas',
  String busca = '',
  bool favoritos = false,
}) {
  final query = normalize(busca);
  return locais
      .where(
        (l) =>
            l.cidade == cidade &&
            (categoria == 'Todas' || l.categoria == categoria) &&
            (!favoritos || l.favorito) &&
            (normalize(l.nome).contains(query) ||
                normalize(l.categoria).contains(query)),
      )
      .toList();
}
