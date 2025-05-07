import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/app/router/router.notifier.dart';
import 'package:red_flags/app/screens/search_screen/search_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:red_flags/app/widgets/animations/fade_widget.dart';
import 'package:red_flags/app/widgets/animations/slide_widget.dart';
import 'package:red_flags/app/widgets/shakles/shakle_text.dart';
import 'dart:async';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<SplashScreen> with TickerProviderStateMixin {
  /// Duration of the splashscreen.
  final _splashscreenDuration = Duration(milliseconds: 3000);

  /// Pager animation controller.
  late final PageController _pageController;
  final _pageSwapDuration = Duration(milliseconds: 400);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    /// * Pager controller for my stickman custom animation.
    _pageController = PageController(initialPage: 0, viewportFraction: 0.6);
    _pageController.addListener(() {
      /// * Every time page is moving, we check if the page value is round because it mean that the animation is completed and we can start the new one.
      if (_pageController.page!.roundToDouble() == _pageController.page && _pageController.page! < 5) {
        _currentPage += 1;
        _pageController.animateToPage(_currentPage, duration: _pageSwapDuration, curve: Curves.easeInOut);
      }
    });

    /// * We need to wait that the view have been builted before moving the first page.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _currentPage = 1;
      _pageController.animateToPage(_currentPage, duration: _pageSwapDuration, curve: Curves.easeInOut);
    });

    /// * Timer for splashscreen animation duration. Then push to HomeScreen.
    Future.delayed(_splashscreenDuration, () {
      ref.read(routerNotifierprovider.notifier).changeScreen(() {
        if (!mounted) return;
        final navigator = Navigator.of(context);
        navigator.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const SearchScreen()), (route) => false);
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final pagerHeight = MediaQuery.of(context).size.height / 3;

    return Scaffold(
      body: Stack(
        children: [
          /// * Title.
          SlideWidget(
            duration: Duration(milliseconds: 400),
            child: Center(
              child: ShakleText(
                animColor: Theme.of(context).colorScheme.primary,
                AppLocalizations.of(context)!.title,
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
          ),

          /// * Pager with Stickmans.
          FadeWidget(
            duration: Duration(milliseconds: 400),
            child: Align(
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
          ),
        ],
      ),
    );
  }
}
