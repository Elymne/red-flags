import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:red_flags/app/screens/splash_screen/splash_screen.dart';
import 'package:red_flags/core/themes/light_theme.dart';

class WebApp extends StatelessWidget {
  const WebApp({super.key});

  /// * This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    /// * Run the views and styles.
    return MaterialApp(
      title: "Red-Flags",
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale("fr"),
      theme: CustomTheme.lightTheme,
      home: SplashScreen(),
      // home: DetailedPersonScreen(id: "8065AD20293646938819766643F7A5A8"),
    );
  }
}
