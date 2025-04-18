import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/app/mobile_app.dart';
import 'package:red_flags/app/web_app.dart';

Future main() async {
  // Make sure env file is loaded before starting the app.
  await dotenv.load(fileName: ".env");

  // Hello.
  WidgetsFlutterBinding.ensureInitialized();

  // Check if it's a web context.
  if (kIsWeb) {
    runApp(ProviderScope(child: const WebApp()));
    return;
  }

  // Run Mobile version.
  runApp(ProviderScope(child: const MobileApp()));
}
