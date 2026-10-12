import 'package:flutter/material.dart';

import '../models/aluno.dart';
import '../repositories/aluno_repository.dart';
import '../widgets/aluno_card.dart';
import '../widgets/aluno_form.dart';

class AlunosPage extends StatefulWidget {
  const AlunosPage({super.key, required this.repository});

  final AlunoRepository repository;

  @override
  State<AlunosPage> createState() => _AlunosPageState();
}

class _AlunosPageState extends State<AlunosPage> {
  late final Stream<List<Aluno>> _alunosStream;
  final TextEditingController _pesquisaController = TextEditingController();
  String _pesquisa = '';

  @override
  void initState() {
    super.initState();
    _alunosStream = widget.repository.observarAlunos();
    _pesquisaController.addListener(() {
      setState(() {
        _pesquisa = _pesquisaController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _pesquisaController.dispose();
    widget.repository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Alunos'),
        centerTitle: false,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(),
        icon: const Icon(Icons.add),
        label: const Text('Novo aluno'),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth < 720 ? 16.0 : 32.0;

            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 920),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    16,
                    horizontalPadding,
                    24,
                  ),
                  child: StreamBuilder<List<Aluno>>(
                    stream: _alunosStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return _EstadoMensagem(
                          icon: Icons.error_outline,
                          titulo: 'Nao foi possivel carregar os alunos.',
                          mensagem:
                              'Tente novamente em alguns instantes. Se estiver usando Firebase, confira a configuracao.',
                        );
                      }

                      final alunos = snapshot.data ?? [];
                      final alunosFiltrados = _filtrarAlunos(alunos);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _Cabecalho(
                            totalAlunos: alunos.length,
                            totalEncontrados: alunosFiltrados.length,
                            pesquisaAtiva: _pesquisa.isNotEmpty,
                            pesquisaController: _pesquisaController,
                            onLimparPesquisa: _pesquisaController.clear,
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: _ListaAlunos(
                              alunos: alunosFiltrados,
                              semAlunos: alunos.isEmpty,
                              pesquisaAtiva: _pesquisa.isNotEmpty,
                              onEditar: _abrirFormulario,
                              onExcluir: _confirmarExclusao,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<Aluno> _filtrarAlunos(List<Aluno> alunos) {
    if (_pesquisa.isEmpty) {
      return alunos;
    }

    return alunos.where((aluno) {
      return aluno.nome.toLowerCase().contains(_pesquisa) ||
          aluno.curso.toLowerCase().contains(_pesquisa) ||
          aluno.email.toLowerCase().contains(_pesquisa);
    }).toList();
  }

  Future<void> _abrirFormulario([Aluno? aluno]) async {
    final resultado = await _mostrarFormularioResponsivo(aluno);
    if (resultado == null || !mounted) {
      return;
    }

    try {
      if (aluno == null) {
        await widget.repository.cadastrarAluno(resultado);
        _mostrarMensagem('Aluno cadastrado com sucesso.');
      } else {
        await widget.repository.atualizarAluno(resultado);
        _mostrarMensagem('Aluno atualizado com sucesso.');
      }
    } catch (_) {
      _mostrarMensagem(
        'Nao foi possivel salvar o aluno. Confira os dados e tente novamente.',
        erro: true,
      );
    }
  }

  Future<Aluno?> _mostrarFormularioResponsivo(Aluno? aluno) {
    final largura = MediaQuery.sizeOf(context).width;

    if (largura >= 720) {
      return showDialog<Aluno>(
        context: context,
        builder: (context) => Dialog(
          insetPadding: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: AlunoForm(aluno: aluno),
          ),
        ),
      );
    }

    return showModalBottomSheet<Aluno>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          MediaQuery.viewInsetsOf(context).bottom + 20,
        ),
        child: AlunoForm(aluno: aluno),
      ),
    );
  }

  Future<void> _confirmarExclusao(Aluno aluno) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir aluno?'),
        content: Text('Deseja realmente excluir ${aluno.nome}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.of(context).pop(true),
            icon: const Icon(Icons.delete_outline),
            label: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmar != true || !mounted) {
      return;
    }

    try {
      await widget.repository.excluirAluno(aluno.id);
      _mostrarMensagem('Aluno excluido com sucesso.');
    } catch (_) {
      _mostrarMensagem(
        'Nao foi possivel excluir o aluno. Tente novamente.',
        erro: true,
      );
    }
  }

  void _mostrarMensagem(String texto, {bool erro = false}) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(texto),
        backgroundColor: erro ? Theme.of(context).colorScheme.error : null,
      ),
    );
  }
}

class _Cabecalho extends StatelessWidget {
  const _Cabecalho({
    required this.totalAlunos,
    required this.totalEncontrados,
    required this.pesquisaAtiva,
    required this.pesquisaController,
    required this.onLimparPesquisa,
  });

  final int totalAlunos;
  final int totalEncontrados;
  final bool pesquisaAtiva;
  final TextEditingController pesquisaController;
  final VoidCallback onLimparPesquisa;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final contador = pesquisaAtiva
        ? 'Total de alunos: $totalAlunos - encontrados: $totalEncontrados'
        : 'Total de alunos: $totalAlunos';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Meus Alunos',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: pesquisaController,
          decoration: InputDecoration(
            hintText: 'Pesquisar aluno...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: pesquisaAtiva
                ? IconButton(
                    tooltip: 'Limpar pesquisa',
                    onPressed: onLimparPesquisa,
                    icon: const Icon(Icons.close),
                  )
                : null,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(
              Icons.groups_2_outlined,
              size: 20,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                contador,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ListaAlunos extends StatelessWidget {
  const _ListaAlunos({
    required this.alunos,
    required this.semAlunos,
    required this.pesquisaAtiva,
    required this.onEditar,
    required this.onExcluir,
  });

  final List<Aluno> alunos;
  final bool semAlunos;
  final bool pesquisaAtiva;
  final void Function(Aluno aluno) onEditar;
  final void Function(Aluno aluno) onExcluir;

  @override
  Widget build(BuildContext context) {
    if (semAlunos) {
      return const _EstadoMensagem(
        icon: Icons.person_add_alt_1_outlined,
        titulo: 'Nenhum aluno cadastrado.',
        mensagem: 'Cadastre o primeiro aluno para comecar.',
      );
    }

    if (alunos.isEmpty && pesquisaAtiva) {
      return const _EstadoMensagem(
        icon: Icons.search_off_outlined,
        titulo: 'Nenhum aluno encontrado.',
        mensagem: 'Nenhum aluno encontrado para essa pesquisa.',
      );
    }

    return ListView.builder(
      itemCount: alunos.length,
      itemBuilder: (context, index) {
        final aluno = alunos[index];
        return AlunoCard(
          aluno: aluno,
          onEditar: () => onEditar(aluno),
          onExcluir: () => onExcluir(aluno),
        );
      },
    );
  }
}

class _EstadoMensagem extends StatelessWidget {
  const _EstadoMensagem({
    required this.icon,
    required this.titulo,
    required this.mensagem,
  });

  final IconData icon;
  final String titulo;
  final String mensagem;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              mensagem,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
