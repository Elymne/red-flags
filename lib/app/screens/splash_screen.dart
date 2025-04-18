import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/app/widgets/ellipsis_text_animated.dart';
import 'package:red_flags/providers/checkApp.provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(checkAppProvider.notifier).runCheck();
  }

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(checkAppProvider).status;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Title.
            SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.title,
              style: Theme.of(context).textTheme.displayLarge,
            ),

            // Loading Status Messages.
            SizedBox(height: 20),
            if (status == CheckAppState.loading)
              EllipsisTextAnimated(
                AppLocalizations.of(context)!.checkLoading,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            if (status == CheckAppState.success)
              Text(
                AppLocalizations.of(context)!.checkSuccess,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            if (status == CheckAppState.failure)
              Text(
                AppLocalizations.of(context)!.checkFailure,
                style: Theme.of(context).textTheme.labelLarge,
              ),

            // Loading Animation.
            SizedBox(height: 20),
            if (status == CheckAppState.loading)
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),

            // Bottom Marge.
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
