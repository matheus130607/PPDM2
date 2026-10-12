import 'package:flutter/material.dart';

import '../models/local.dart';

class DetalhesScreen extends StatelessWidget {
  const DetalhesScreen({
    super.key,
    required this.local,
    required this.onFavorite,
    required this.onMap,
    required this.onBack,
    this.busy = false,
  });
  final Local local;
  final VoidCallback onFavorite, onMap, onBack;
  final bool busy;
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back),
            label: const Text('Voltar'),
          ),
        ),
        Container(
          height: 160,
          decoration: BoxDecoration(
            color: const Color(0xffd4e9eb),
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.storefront, size: 70, color: Color(0xff006875)),
              Text('Imagem indisponível'),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(local.nome, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text('${local.categoria} • ${local.cidade}'),
        const SizedBox(height: 20),
        Text(
          'Avaliação ${local.avaliacao.toStringAsFixed(1)} / 5 • ${local.distancia.toStringAsFixed(1)} km cadastrados',
        ),
        const SizedBox(height: 20),
        Text(
          'Horário: ${local.horario.isEmpty ? 'Não informado' : local.horario}',
        ),
        const SizedBox(height: 16),
        Text(
          local.descricao.isEmpty
              ? 'Descrição não informada.'
              : local.descricao,
        ),
        const SizedBox(height: 28),
        FilledButton.icon(
          onPressed: busy ? null : onFavorite,
          icon: Icon(local.favorito ? Icons.favorite : Icons.favorite_border),
          label: Text(local.favorito ? 'Remover favorito' : 'Marcar favorito'),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: onMap,
          icon: const Icon(Icons.map_outlined),
          label: const Text('Ver no mapa'),
        ),
      ],
    ),
  );
}
