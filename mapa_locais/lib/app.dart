import 'package:flutter/material.dart';

import 'models/local.dart';
import 'services/local_service.dart';
import 'screens/mapa_screen.dart';
import 'screens/resultados_screen.dart';
import 'screens/detalhes_screen.dart';
import 'widgets/local_form.dart';
import 'widgets/login_dialog.dart';
import 'dialogs/confirm_delete.dart';
import 'utils/filters.dart';
import 'utils/feedback.dart';

class MapaLocaisApp extends StatelessWidget {
  const MapaLocaisApp({super.key, this.repository});
  final LocalRepository? repository;
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Mapa de Locais',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xfff5f8fa),
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff006875)),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    ),
    home: _Home(repository: repository),
  );
}

class _Home extends StatefulWidget {
  const _Home({required this.repository});
  final LocalRepository? repository;
  @override
  State<_Home> createState() => _HomeState();
}

class _HomeState extends State<_Home> {
  final _search = TextEditingController();
  final _busy = <String>{};
  late Stream<List<Local>>? _stream;
  String _cidade = cidades.first, _categoria = 'Todas';
  String? _selected, _highlight;
  int _tab = 0;
  bool _favoritos = false;
  @override
  void initState() {
    super.initState();
    _stream = widget.repository?.listarLocais();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _open(Local local) => setState(() => _selected = local.id);
  Future<void> _action(
    Local local,
    Future<void> Function() action,
    String success,
  ) async {
    if (_busy.contains(local.id)) {
      return;
    }
    setState(() => _busy.add(local.id));
    try {
      await action();
      if (mounted) {
        feedback(context, success);
      }
    } catch (e) {
      if (mounted) {
        feedback(context, errorMessage(e));
      }
    } finally {
      if (mounted) {
        setState(() => _busy.remove(local.id));
      }
    }
  }

  Future<void> _delete(Local local) async {
    if (_busy.contains(local.id)) {
      return;
    }
    if (await confirmDelete(context, local.nome) && mounted) {
      await _action(
        local,
        () => widget.repository!.excluir(local.id),
        'Local excluído.',
      );
    }
  }

  void _map(Local local) => setState(() {
    _selected = null;
    _highlight = local.id;
    _cidade = local.cidade;
    _categoria = 'Todas';
    _favoritos = false;
    _search.clear();
    _tab = 0;
  });
  @override
  Widget build(BuildContext context) => PopScope(
    canPop: _selected == null && _tab == 0,
    onPopInvokedWithResult: (didPop, result) {
      if (!didPop) {
        setState(() {
          _selected = null;
          _tab = 0;
          _favoritos = false;
        });
      }
    },
    child: Scaffold(
      appBar: AppBar(
        title: Text(
          _selected != null
              ? 'Detalhes do local'
              : _tab == 0
              ? 'Mapa de Locais'
              : 'Resultados',
        ),
        actions: [
          if (widget.repository is LocalService)
            IconButton(
              tooltip: 'Conta autorizada',
              onPressed: () async {
                await showLoginDialog(context);
                if (mounted) {
                  setState(() => _stream = widget.repository!.listarLocais());
                }
              },
              icon: const Icon(Icons.account_circle_outlined),
            ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: widget.repository == null
              ? _setup()
              : StreamBuilder<List<Local>>(
                  stream: _stream,
                  builder: (context, snapshot) {
                    final all = snapshot.data ?? [];
                    final selected = all
                        .where((l) => l.id == _selected)
                        .firstOrNull;
                    if (snapshot.hasError) {
                      return _status(
                        errorMessage(snapshot.error!),
                        retry: true,
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (_selected != null) {
                      if (selected == null) {
                        return _status(
                          'Este local não está mais disponível.',
                          back: true,
                        );
                      }
                      return DetalhesScreen(
                        local: selected,
                        busy: _busy.contains(selected.id),
                        onBack: () => setState(() => _selected = null),
                        onMap: () => _map(selected),
                        onFavorite: () => _action(
                          selected,
                          () => widget.repository!.alterarFavorito(
                            selected.id,
                            !selected.favorito,
                          ),
                          'Favorito atualizado.',
                        ),
                      );
                    }
                    final filtered = filtrar(
                      all,
                      cidade: _cidade,
                      categoria: _categoria,
                      busca: _search.text,
                      favoritos: _favoritos,
                    );
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: Column(
                            children: [
                              DropdownButtonFormField<String>(
                                key: ValueKey(_cidade),
                                initialValue: _cidade,
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  labelText: 'Cidade selecionada',
                                  prefixIcon: Icon(Icons.location_city),
                                ),
                                items: {...cidades, ...all.map((l) => l.cidade)}
                                    .where((c) => c.isNotEmpty)
                                    .map(
                                      (c) => DropdownMenuItem(
                                        value: c,
                                        child: Text(c),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (v) => setState(() {
                                  _cidade = v!;
                                  _highlight = null;
                                }),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _search,
                                onChanged: (_) => setState(() {}),
                                decoration: InputDecoration(
                                  labelText: 'Buscar por nome ou categoria',
                                  prefixIcon: const Icon(Icons.search),
                                  suffixIcon: IconButton(
                                    tooltip: 'Limpar pesquisa',
                                    onPressed: () =>
                                        setState(() => _search.clear()),
                                    icon: const Icon(Icons.close),
                                  ),
                                ),
                              ),
                              if (_tab == 1) ...[
                                const SizedBox(height: 8),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      for (final category in {
                                        'Todas',
                                        ...categorias,
                                        ...all.map((l) => l.categoria),
                                      }.where((c) => c.isNotEmpty))
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            right: 8,
                                          ),
                                          child: ChoiceChip(
                                            label: Text(category),
                                            selected: _categoria == category,
                                            onSelected: (_) => setState(
                                              () => _categoria = category,
                                            ),
                                          ),
                                        ),
                                      FilterChip(
                                        label: const Text('Só favoritos'),
                                        selected: _favoritos,
                                        onSelected: (v) =>
                                            setState(() => _favoritos = v),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        Expanded(
                          child: _tab == 0
                              ? MapaScreen(
                                  locais: filtered,
                                  highlight: _highlight,
                                  onOpen: _open,
                                  onResults: () => setState(() => _tab = 1),
                                )
                              : ResultadosScreen(
                                  locais: filtered,
                                  busy: _busy,
                                  onOpen: _open,
                                  onDelete: _delete,
                                  onFavorite: (l) => _action(
                                    l,
                                    () => widget.repository!.alterarFavorito(
                                      l.id,
                                      !l.favorito,
                                    ),
                                    'Favorito atualizado.',
                                  ),
                                  onEdit: (l) => showLocalForm(
                                    context,
                                    widget.repository!,
                                    _cidade,
                                    local: l,
                                  ),
                                ),
                        ),
                      ],
                    );
                  },
                ),
        ),
      ),
      floatingActionButton:
          widget.repository != null && _selected == null && _tab == 1
          ? FloatingActionButton.extended(
              onPressed: () =>
                  showLocalForm(context, widget.repository!, _cidade),
              icon: const Icon(Icons.add),
              label: const Text('Cadastrar'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _favoritos && _tab == 1 ? 2 : _tab,
        onDestinationSelected: (v) => setState(() {
          _selected = null;
          _tab = v == 0 ? 0 : 1;
          _favoritos = v == 2;
        }),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.map_outlined), label: 'Mapa'),
          NavigationDestination(
            icon: Icon(Icons.view_list_outlined),
            label: 'Resultados',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            label: 'Favoritos',
          ),
        ],
      ),
    ),
  );
  Widget _setup() => SingleChildScrollView(
    padding: const EdgeInsets.all(32),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.cloud_off_outlined,
          size: 72,
          color: Color(0xff006875),
        ),
        const SizedBox(height: 24),
        Text(
          'Conecte seu Firebase',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        const Text(
          'A conexão real ainda não foi configurada. Nenhum estabelecimento é simulado nesta versão.\n\n'
          'Execute scripts/configure_firebase.ps1 com o Project ID real e siga docs/FIREBASE_SETUP.md. Depois recompile o aplicativo.',
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
  Widget _status(String message, {bool retry = false, bool back = false}) =>
      Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.info_outline, size: 48),
              const SizedBox(height: 16),
              Text(message, textAlign: TextAlign.center),
              if (retry)
                TextButton(
                  onPressed: () => setState(
                    () => _stream = widget.repository!.listarLocais(),
                  ),
                  child: const Text('Tentar novamente'),
                ),
              if (back)
                TextButton(
                  onPressed: () => setState(() => _selected = null),
                  child: const Text('Voltar'),
                ),
            ],
          ),
        ),
      );
}
