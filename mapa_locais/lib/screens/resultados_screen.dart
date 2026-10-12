import 'package:flutter/material.dart';

import '../models/local.dart';
import '../widgets/local_card.dart';

class ResultadosScreen extends StatelessWidget {
  const ResultadosScreen({
    super.key,
    required this.locais,
    required this.busy,
    required this.onOpen,
    required this.onFavorite,
    required this.onEdit,
    required this.onDelete,
  });
  final List<Local> locais;
  final Set<String> busy;
  final ValueChanged<Local> onOpen, onFavorite, onEdit, onDelete;
  @override
  Widget build(BuildContext context) => locais.isEmpty
      ? const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Nenhum local encontrado.\nAjuste os filtros ou cadastre um estabelecimento.',
              textAlign: TextAlign.center,
            ),
          ),
        )
      : ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 90),
          itemCount: locais.length,
          itemBuilder: (context, i) {
            final l = locais[i];
            return LocalCard(
              local: l,
              busy: busy.contains(l.id),
              onOpen: () => onOpen(l),
              onFavorite: () => onFavorite(l),
              onEdit: () => onEdit(l),
              onDelete: () => onDelete(l),
            );
          },
        );
}
