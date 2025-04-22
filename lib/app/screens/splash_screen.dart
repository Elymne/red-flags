import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/app/screens/home_screen.dart';
import 'package:red_flags/providers/checkApp.provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:async';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  //Timming for fadeout anim + navigation.
  final timing = Duration(seconds: 1);
  // The controller Animation for the fadeout screen on checking done.
  late final AnimationController _controller = AnimationController(
    duration: timing,
    vsync: this,
  );
  late final Animation<double> _fadeoutAnimation = Tween(
    begin: 1.0,
    end: 0.0,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

  @override
  void initState() {
    super.initState();
    ref.read(checkAppProvider.notifier).runCheck();
    _fadeoutAnimation.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(checkAppProvider).status;
    if (status == CheckAppState.success) {
      // Run fadeout animation.
      _controller.forward();
      // And navigate to home when animation is over.
      final navigator = Navigator.of(context);
      Future.delayed(timing, () {
        if (!mounted) return;
        navigator.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      });
    }

    return Scaffold(
      body: Opacity(
        opacity: _fadeoutAnimation.value,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Title.
              Text(
                AppLocalizations.of(context)!.title,
                style: Theme.of(context).textTheme.displayLarge,
              ),

              SizedBox(height: 20),

              // Loading Status Messages.
              if (status == CheckAppState.loading)
                Text(
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

              SizedBox(height: 20),

              // Loading Animation.
              if (status == CheckAppState.loading)
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
