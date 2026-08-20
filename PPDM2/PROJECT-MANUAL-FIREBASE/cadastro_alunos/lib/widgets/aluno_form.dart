import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/aluno.dart';

class AlunoForm extends StatefulWidget {
  const AlunoForm({super.key, this.aluno});

  final Aluno? aluno;

  @override
  State<AlunoForm> createState() => _AlunoFormState();
}

class _AlunoFormState extends State<AlunoForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomeController;
  late final TextEditingController _idadeController;
  late final TextEditingController _cursoController;
  late final TextEditingController _emailController;

  bool get _editando => widget.aluno != null;

  @override
  void initState() {
    super.initState();
    final aluno = widget.aluno;
    _nomeController = TextEditingController(text: aluno?.nome ?? '');
    _idadeController = TextEditingController(
      text: aluno == null ? '' : aluno.idade.toString(),
    );
    _cursoController = TextEditingController(text: aluno?.curso ?? '');
    _emailController = TextEditingController(text: aluno?.email ?? '');
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _idadeController.dispose();
    _cursoController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 560),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _editando ? 'Editar aluno' : 'Novo aluno',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Fechar',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nomeController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: _validarNome,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _idadeController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Idade',
                  prefixIcon: Icon(Icons.calendar_today_outlined),
                ),
                validator: _validarIdade,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _cursoController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Curso',
                  prefixIcon: Icon(Icons.school_outlined),
                ),
                validator: _validarCurso,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: Icon(Icons.mail_outline),
                ),
                validator: _validarEmail,
                onFieldSubmitted: (_) => _salvar(),
              ),
              const SizedBox(height: 22),
              FilledButton.icon(
                onPressed: _salvar,
                icon: Icon(_editando ? Icons.save_outlined : Icons.add),
                label: Text(_editando ? 'Salvar alteracoes' : 'Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _validarNome(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Preencha o nome do aluno.';
    }
    return null;
  }

  String? _validarIdade(String? value) {
    final idade = int.tryParse(value?.trim() ?? '');
    if (idade == null || idade < 1 || idade > 120) {
      return 'Informe uma idade valida.';
    }
    return null;
  }

  String? _validarCurso(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Preencha o curso.';
    }
    return null;
  }

  String? _validarEmail(String? value) {
    final email = value?.trim() ?? '';
    final emailValido = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
    if (!emailValido) {
      return 'Informe um e-mail valido.';
    }
    return null;
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final aluno = Aluno(
      id: widget.aluno?.id ?? '',
      nome: _nomeController.text.trim(),
      idade: int.parse(_idadeController.text.trim()),
      curso: _cursoController.text.trim(),
      email: _emailController.text.trim(),
    );

    Navigator.of(context).pop(aluno);
  }
}
