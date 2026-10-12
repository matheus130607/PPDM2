import 'package:flutter/material.dart';

import 'app.dart';
import 'firebase_bootstrap.dart';
import 'services/local_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocalRepository? repository;
  try {
    await initializeBackend();
    repository = LocalService();
  } catch (_) {}
  runApp(MapaLocaisApp(repository: repository));
}
