import 'package:flutter/widgets.dart';

import 'app/app.dart';
import 'app/app_initializer.dart';

Future<void> main() async {
  await AppInitializer.ensureInitialized();
  runApp(const App());
}
