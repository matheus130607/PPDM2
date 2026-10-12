import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mapa_locais/firebase_bootstrap.dart';
import 'package:mapa_locais/services/local_service.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('T01 read real Firestore using the approved account', (
    tester,
  ) async {
    await initializeBackend();
    expect(
      FirebaseAuth.instance.currentUser,
      isNotNull,
      reason: 'Entre antes no aplicativo com a conta autorizada. Não fornecer senhas na linha de comando.',
    );
    final server = await FirebaseFirestore.instance
        .collection('locais')
        .get(const GetOptions(source: Source.server))
        .timeout(const Duration(seconds: 20));
    expect(
      server.docs,
      isNotEmpty,
      reason: 'A leitura deve ser confirmada pelo servidor, não somente pelo cache.',
    );
    final locals = await LocalService().listarLocais().first.timeout(
      const Duration(seconds: 20),
    );
    expect(
      locals,
      isNotEmpty,
      reason: 'Cadastre documentos reais ou execute a carga após aprovação.',
    );
    expect(locals.every((local) => local.id.isNotEmpty), isTrue);
  });
}
