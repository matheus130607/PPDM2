import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'repositories/aluno_repository.dart';
import 'repositories/firestore_aluno_repository.dart';
import 'repositories/memory_aluno_repository.dart';
import 'screens/alunos_page.dart';

const bool useFirebase = true;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // TODO FIREBASE:
  // Depois de configurar Firebase no Android e gerar as opcoes oficiais,
  // inicializar Firebase aqui antes de usar FirestoreAlunoRepository.

  final AlunoRepository repository = useFirebase
      ? FirestoreAlunoRepository()
      : MemoryAlunoRepository(comDadosDeExemplo: true);

  runApp(CadastroAlunosApp(repository: repository));
}

class CadastroAlunosApp extends StatelessWidget {
  const CadastroAlunosApp({super.key, required this.repository});

  final AlunoRepository repository;

  @override
  Widget build(BuildContext context) {
    const seedColor = Color(0xFF25636F);

    return MaterialApp(
      title: 'Cadastro de Alunos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF6F7F8),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.white,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.grey.shade200),
          ),
        ),
      ),
      home: AlunosPage(repository: repository),
    );
  }
}
