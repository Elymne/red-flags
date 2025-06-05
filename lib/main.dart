import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:red_flags/presentation/mobile_app.dart';
import 'package:red_flags/presentation/web_app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';

Future main() async {
  /// * Initialize date formatting for a specific locale (e.g. French)
  await initializeDateFormatting("fr_FR", null);

  /// * Make sure env file is loaded before starting the app.
  await dotenv.load(fileName: ".env");

  /// * Allow me to test UI.
  debugPaintSizeEnabled = false;

  /// * Hello.
  WidgetsFlutterBinding.ensureInitialized();

  /// * Check if it's a web context.
  if (kIsWeb) {
    runApp(ProviderScope(child: const WebApp()));
    return;
  }

  /// * Run Mobile version.
  runApp(ProviderScope(child: const MobileApp()));
}
