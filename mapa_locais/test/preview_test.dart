import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapa_locais/app.dart';
import 'package:mapa_locais/models/local.dart';

import 'support/test_repository.dart';

void main() {
  testWidgets('Phone rendering: three clearly labelled simulated previews', (
    t,
  ) async {
    final originalShadows = debugDisableShadows;
    debugDisableShadows = false;
    addTearDown(() => debugDisableShadows = originalShadows);
    await t.runAsync(() async {
      final font = File(
        '${Platform.environment['WINDIR'] ?? 'C:\\Windows'}/Fonts/segoeui.ttf',
      );
      if (font.existsSync()) {
        await (FontLoader('Roboto')..addFont(
              Future.value(ByteData.sublistView(font.readAsBytesSync())),
            ))
            .load();
      }
      await (FontLoader(
        'MaterialIcons',
      )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
    });
    t.view.physicalSize = const Size(390, 844);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.resetPhysicalSize);
    addTearDown(t.view.resetDevicePixelRatio);
    final r = TestRepository(
      List.generate(
        5,
        (i) => Local.fromMap('test-$i', {
          'nome': [
            'Academia Horizonte',
            'Restaurante Jardim',
            'Hospital Central',
            'Academia Movimento',
            'Restaurante Sabores',
          ][i],
          'categoria': [
            'Academia',
            'Restaurante',
            'Hospital',
            'Academia',
            'Restaurante',
          ][i],
          'cidade': 'São Paulo',
          'avaliacao': 4.8 - i * .2,
          'distancia': 1.2 + i,
          'horario': '06:00 - 22:00',
          'descricao':
              'Estabelecimento fictício para teste visual da interface.',
        }),
      ),
    );
    addTearDown(r.dispose);
    final key = GlobalKey();
    await t.pumpWidget(
      RepaintBoundary(
        key: key,
        child: Column(
          children: [
            const Directionality(
              textDirection: TextDirection.ltr,
              child: ColoredBox(
                color: Colors.amber,
                child: SizedBox(
                  width: double.infinity,
                  height: 28,
                  child: Center(
                    child: Text(
                      'PRÉVIA DE TESTE • DADOS SIMULADOS',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(child: MapaLocaisApp(repository: r)),
          ],
        ),
      ),
    );
    await t.pumpAndSettle();
    Future<void> capture(String name) async {
      expect(t.takeException(), isNull);
      final boundary =
          key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      await t.runAsync(() async {
        final image = await boundary.toImage(pixelRatio: 1.5);
        final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
        await File('docs/capturas/$name')
            .writeAsBytes(bytes!.buffer.asUint8List());
        image.dispose();
      });
    }

    await capture('previa_teste_01_mapa.png');
    await t.tap(find.text('Resultados').last);
    await t.pumpAndSettle();
    await capture('previa_teste_02_resultados.png');
    await t.tap(find.text('Academia Horizonte'));
    await t.pumpAndSettle();
    await capture('previa_teste_03_detalhes.png');
    t.view.physicalSize = const Size(320, 640);
    await t.pumpAndSettle();
    expect(t.takeException(), isNull);
    debugDisableShadows = originalShadows;
  });
}
