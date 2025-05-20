import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:red_flags/app/screens/create_person_screen/create_person_screen.dart';
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
      home: CreatePersonScreen(),
    );
  }
}
