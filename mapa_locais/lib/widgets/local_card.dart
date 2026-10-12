import 'package:flutter/material.dart';

import '../models/local.dart';

class LocalCard extends StatelessWidget {
  const LocalCard({
    super.key,
    required this.local,
    required this.onOpen,
    required this.onFavorite,
    required this.onEdit,
    required this.onDelete,
    this.busy = false,
  });
  final Local local;
  final VoidCallback onOpen, onFavorite, onEdit, onDelete;
  final bool busy;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          ListTile(
            onTap: onOpen,
            contentPadding: EdgeInsets.zero,
            leading: const CircleAvatar(child: Icon(Icons.storefront)),
            title: Text(
              local.nome,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: Text(
              '${local.categoria} • ${local.cidade}\n${local.distancia.toStringAsFixed(1)} km cadastrados • Nota ${local.avaliacao.toStringAsFixed(1)}',
            ),
            isThreeLine: true,
            trailing: IconButton(
              tooltip: local.favorito
                  ? 'Desmarcar favorito'
                  : 'Marcar favorito',
              onPressed: busy ? null : onFavorite,
              icon: Icon(
                local.favorito ? Icons.favorite : Icons.favorite_border,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: busy ? null : onEdit,
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Editar'),
              ),
              TextButton.icon(
                onPressed: busy ? null : onDelete,
                icon: const Icon(Icons.delete_outline),
                label: const Text('Excluir'),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
