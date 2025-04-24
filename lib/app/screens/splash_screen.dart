import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:red_flags/app/screens/home_screen.dart';
import 'package:red_flags/core/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:async';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with TickerProviderStateMixin {
  /// Duration of the splashscreen.
  final _splashscreenDuration = Duration(milliseconds: 3000);

  /// Pager animation controller.
  late final PageController _pageController;
  final _pageSwapDuration = Duration(milliseconds: 400);
  int _currentPage = 0;

  /// Shake Animation for title.
  late final AnimationController _idleController1;
  late final Animation<double> _shakeAnimation1;
  final Duration _shakeDuration1 = Duration(milliseconds: 100);

  late final AnimationController _idleController2;
  late final Animation<double> _shakeAnimation2;
  final Duration _shakeDuration2 = Duration(milliseconds: 200);

  /// Opacity Animation
  late final AnimationController _opacityController;
  late final Animation<double> _opacityAnimation;
  final Duration _opacityDuration = Duration(milliseconds: 400);

  @override
  void initState() {
    super.initState();
    // Pager controller for my stickman custom animation.
    _pageController = PageController(initialPage: 0, viewportFraction: 0.6);
    _pageController.addListener(() {
      // Every time page is moving, we check if the page value is round because it mean that the animation is completed and we can start the new one.
      if (_pageController.page!.roundToDouble() == _pageController.page && _pageController.page! < 5) {
        _currentPage += 1;
        _pageController.animateToPage(_currentPage, duration: _pageSwapDuration, curve: Curves.easeInOut);
      }
    });
    // We need to wait that the view have been builted before moving the first page.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _currentPage = 1;
      _pageController.animateToPage(_currentPage, duration: _pageSwapDuration, curve: Curves.easeInOut);
    });

    // Background text animation (red text).
    _idleController1 = AnimationController(vsync: this, duration: _shakeDuration1);
    _shakeAnimation1 = Tween<double>(begin: -1, end: 1).animate(_idleController1);
    _shakeAnimation1.addStatusListener((status) {
      if (status == AnimationStatus.completed) _idleController1.reverse();
      if (status == AnimationStatus.dismissed) _idleController1.forward();
    });
    _idleController1.forward();

    // Frontend text animation (black text).
    _idleController2 = AnimationController(vsync: this, duration: _shakeDuration2);
    _shakeAnimation2 = Tween<double>(begin: -1.4, end: 1.4).animate(_idleController2);
    _shakeAnimation2.addStatusListener((status) {
      if (status == AnimationStatus.completed) _idleController2.reverse();
      if (status == AnimationStatus.dismissed) _idleController2.forward();
    });
    _idleController2.forward();

    // Opacity Animation (when animation is done).
    _opacityController = AnimationController(vsync: this, duration: _opacityDuration);
    _opacityAnimation = Tween<double>(begin: 1, end: 0).animate(_opacityController);
    _opacityAnimation.addListener(() => setState(() {}));

    // When animation is done, navigate to Home Page.
    Future.delayed(_splashscreenDuration, () {
      _opacityController.forward();
      Future.delayed(_opacityDuration, () {
        if (!mounted) return;
        final navigator = Navigator.of(context);
        navigator.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false);
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _idleController1.dispose();
    _idleController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final pagerHeight = MediaQuery.of(context).size.height / 3;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _opacityAnimation,
        builder: (context, child) {
          // For fadeout animation.
          return Opacity(
            opacity: _opacityAnimation.value,
            child: Stack(
              children: [
                // Background Red Color Title.
                Center(
                  child: AnimatedBuilder(
                    animation: _shakeAnimation1,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(_shakeAnimation1.value, 0),
                        child: Text(
                          AppLocalizations.of(context)!.title,
                          style: GoogleFonts.nunitoSans(color: AppColors.primary, fontWeight: FontWeight.w900, fontSize: 42),
                        ),
                      );
                    },
                  ),
                ),

                // Black Color Title.
                Center(
                  child: AnimatedBuilder(
                    animation: _shakeAnimation2,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(_shakeAnimation2.value, 0),
                        child: Text(
                          AppLocalizations.of(context)!.title,
                          style: GoogleFonts.nunitoSans(color: AppColors.onSurface, fontWeight: FontWeight.w900, fontSize: 42),
                        ),
                      );
                    },
                  ),
                ),

                // Pager with Stickmans.
                Align(
                  alignment: Alignment(0, 1),
                  child: SizedBox(
                    height: pagerHeight,
                    child: PageView.builder(
                      controller: _pageController,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 7,
                      itemBuilder: (context, index) {
                        // I want the two first page to be empty (styling choice).
                        if (index < 2) return SizedBox(width: screenWidth);
                        // For some index, I want the stickman to be shaken with red effect like the title.
                        if (index == 5) return Image.asset("assets/images/stickman_red.png", fit: BoxFit.contain);
                        // Default stickman wont have any animation.
                        return SizedBox(width: double.infinity, child: Image.asset("assets/images/stickman_grey.png", fit: BoxFit.contain));
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
