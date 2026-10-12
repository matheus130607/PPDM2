import 'package:flutter/material.dart';

import '../models/local.dart';
import '../services/local_service.dart';
import '../utils/filters.dart';
import '../utils/feedback.dart';

Future<void> showLocalForm(
  BuildContext context,
  LocalRepository repository,
  String cidade, {
  Local? local,
}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  isDismissible: false,
  enableDrag: false,
  builder: (_) =>
      LocalForm(repository: repository, cidade: cidade, local: local),
);

class LocalForm extends StatefulWidget {
  const LocalForm({
    super.key,
    required this.repository,
    required this.cidade,
    this.local,
  });
  final LocalRepository repository;
  final String cidade;
  final Local? local;
  @override
  State<LocalForm> createState() => _LocalFormState();
}

class _LocalFormState extends State<LocalForm> {
  final _key = GlobalKey<FormState>();
  late final List<TextEditingController> _fields;
  late String _cidade;
  bool _saving = false;
  @override
  void initState() {
    super.initState();
    final l = widget.local;
    _cidade = l?.cidade ?? widget.cidade;
    _fields = [
      l?.nome ?? '',
      l?.categoria ?? '',
      '${l?.avaliacao ?? 0}',
      '${l?.distancia ?? 0}',
      l?.horario ?? '',
      l?.descricao ?? '',
    ].map((v) => TextEditingController(text: v)).toList();
  }

  @override
  void dispose() {
    for (final f in _fields) {
      f.dispose();
    }
    super.dispose();
  }

  String? _required(String? v) =>
      v == null || v.trim().isEmpty ? 'Campo obrigatório' : null;
  String? _number(String? v, bool rating) {
    final n = double.tryParse((v ?? '').replaceAll(',', '.'));
    return n == null || !n.isFinite || n < 0 || (rating && n > 5)
        ? rating
              ? 'Informe um número de 0 a 5'
              : 'Informe uma distância não negativa'
        : null;
  }

  Future<void> _save() async {
    if (_saving || !_key.currentState!.validate()) {
      return;
    }
    setState(() => _saving = true);
    final local = Local(
      id: widget.local?.id ?? '',
      nome: _fields[0].text.trim(),
      categoria: _fields[1].text.trim(),
      cidade: _cidade,
      avaliacao: Local.number(_fields[2].text),
      distancia: Local.number(_fields[3].text),
      horario: _fields[4].text.trim(),
      descricao: _fields[5].text.trim(),
      favorito: widget.local?.favorito ?? false,
    );
    try {
      if (widget.local == null) {
        await widget.repository.adicionar(local);
      } else {
        await widget.repository.atualizar(local);
      }
      if (!mounted) {
        return;
      }
      feedback(context, 'Local salvo com sucesso.');
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        feedback(context, errorMessage(e));
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_saving,
    child: Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        20,
        24,
        MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.local == null ? 'Cadastrar local' : 'Editar local',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),
              for (var i = 0; i < _fields.length; i++) ...[
                TextFormField(
                  controller: _fields[i],
                  enabled: !_saving,
                  maxLength: i == 5 ? 2000 : 120,
                  decoration: InputDecoration(
                    labelText: [
                      'Nome',
                      'Categoria',
                      'Avaliação (0–5)',
                      'Distância (km)',
                      'Horário',
                      'Descrição',
                    ][i],
                    counterText: '',
                  ),
                  maxLines: i == 5 ? 3 : 1,
                  keyboardType: i == 2 || i == 3
                      ? const TextInputType.numberWithOptions(decimal: true)
                      : TextInputType.text,
                  validator: i < 2
                      ? _required
                      : i == 2 || i == 3
                      ? (v) => _number(v, i == 2)
                      : null,
                ),
                const SizedBox(height: 12),
              ],
              DropdownButtonFormField<String>(
                initialValue: _cidade,
                decoration: const InputDecoration(labelText: 'Cidade'),
                items: {...cidades, _cidade}
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: _saving ? null : (v) => setState(() => _cidade = v!),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _saving ? null : _save,
                child: Text(_saving ? 'Salvando…' : 'Salvar no Firestore'),
              ),
              TextButton(
                onPressed: _saving ? null : () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
