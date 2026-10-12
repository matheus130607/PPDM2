import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapa_locais/firebase_bootstrap.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets(
    'CRUD real com a conta aprovada e limpeza do documento de teste',
    (tester) async {
      await initializeBackend();
      expect(Firebase.app().options.projectId, 'mapa-de-locais-c0801');
      expect(
        FirebaseAuth.instance.currentUser?.uid,
        'PJeJ3MtAjId4sIZHN7xtFuq1O9B2',
        reason: 'Faça login no aplicativo com a conta de teste aprovada.',
      );
      final db = FirebaseFirestore.instance;
      const server = GetOptions(source: Source.server);
      final initial = await db.collection('locais').get(server);
      expect(initial.metadata.isFromCache, isFalse);
      expect(initial.docs, isNotEmpty);
      // ID novo: o teste não altera nem exclui os dez exemplos existentes.
      final ref = db.collection('locais').doc();
      var created = false;
      try {
        await ref.set({
          'nome': 'Validação temporária Android',
          'categoria': 'Academia',
          'cidade': 'São Paulo',
          'avaliacao': 4.5,
          'distancia': 1.0,
          'horario': '08:00–18:00',
          'descricao': 'Documento temporário do teste de integração.',
          'favorito': false,
        });
        created = true;
        final inserted = await ref.get(server);
        expect(inserted.metadata.isFromCache, isFalse);
        expect(inserted.data()?['nome'], 'Validação temporária Android');
        await ref.update({
          'nome': 'Validação editada Android',
          'horario': '09:00–19:00',
        });
        final edited = await ref.get(server);
        expect(edited.data()?['nome'], 'Validação editada Android');
        expect(edited.data()?['horario'], '09:00–19:00');
        await ref.update({'favorito': true});
        expect((await ref.get(server)).data()?['favorito'], isTrue);
        await ref.update({'favorito': false});
        expect((await ref.get(server)).data()?['favorito'], isFalse);
        await ref.delete();
        expect((await ref.get(server)).exists, isFalse);
        created = false;
      } finally {
        if (created) await ref.delete();
      }
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );
}
