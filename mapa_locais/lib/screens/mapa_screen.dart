import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/local.dart';

class MapaScreen extends StatelessWidget {
  const MapaScreen({
    super.key,
    required this.locais,
    required this.onOpen,
    required this.onResults,
    this.highlight,
  });
  final List<Local> locais;
  final String? highlight;
  final ValueChanged<Local> onOpen;
  final VoidCallback onResults;
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Explore os locais',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        const Text(
          'Mapa esquemático • posições ilustrativas, sem geolocalização',
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 340,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: LayoutBuilder(
              builder: (context, box) => Stack(
                children: [
                  const Positioned.fill(
                    child: CustomPaint(painter: _MapPainter()),
                  ),
                  for (var i = 0; i < locais.length; i++)
                    Positioned(
                      left: 12 + (box.maxWidth - 68) * ((i * .618 + .12) % 1),
                      top: 14 + 255 * ((i * .381 + .08) % 1),
                      child: IconButton.filled(
                        tooltip: locais[i].nome,
                        style: IconButton.styleFrom(
                          backgroundColor: locais[i].id == highlight
                              ? Colors.orange.shade800
                              : const Color(0xff006875),
                        ),
                        onPressed: () => onOpen(locais[i]),
                        icon: const Icon(Icons.location_on),
                      ),
                    ),
                  if (locais.isEmpty)
                    const Center(
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text('Nenhum local para os filtros atuais.'),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text('${locais.length} estabelecimentos encontrados'),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: onResults,
          icon: const Icon(Icons.list),
          label: const Text('Ver resultados'),
        ),
        const SizedBox(height: 12),
        for (final l in locais.where((l) => l.id == highlight))
          Card(
            child: ListTile(
              title: Text(l.nome),
              subtitle: const Text('Local destacado no esquema'),
              onTap: () => onOpen(l),
            ),
          ),
      ],
    ),
  );
}

class _MapPainter extends CustomPainter {
  const _MapPainter();
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xffe7efea),
    );
    canvas.drawOval(
      Rect.fromLTWH(size.width * .55, 20, size.width * .5, 145),
      Paint()..color = const Color(0xffc4ddc3),
    );
    final road = Paint()
      ..color = Colors.white
      ..strokeWidth = 18;
    for (var i = -2; i < 7; i++) {
      canvas.drawLine(
        Offset(i * 95, 0),
        Offset(i * 95 + 100, size.height),
        road,
      );
    }
    for (var i = 0; i < 4; i++) {
      canvas.drawLine(
        Offset(0, i * 100 + 40),
        Offset(size.width, i * 100 + 20),
        road,
      );
    }
    final path = Path()..moveTo(0, size.height * .8);
    for (var x = 0.0; x <= size.width; x += 5) {
      path.lineTo(x, size.height * .8 + math.sin(x / 70) * 18);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xffacd5e0)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 24,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
