import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:red_flags/core/themes/light_theme.dart';

import 'package:red_flags/app/screens/splash_screen.dart';

class MobileApp extends StatelessWidget {
  const MobileApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Update bottom bar navigation when on android device. Don't know why but the bottom navigation bar stay bright without this.
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(systemNavigationBarColor: null, systemNavigationBarIconBrightness: Brightness.dark),
      );
    }

    // This app is only usable on portrait mode.
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    // Run the views and styles.
    return MaterialApp(
      title: "Red-Flags",
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('fr'),
      theme: CustomTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
