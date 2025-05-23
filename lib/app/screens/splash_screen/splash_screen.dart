import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/app/router/router.notifier.dart';
import 'package:red_flags/app/screens/home_screen/home_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:red_flags/app/widgets/routing/fade_widget.dart';
import 'package:red_flags/app/widgets/routing/slide_widget.dart';
import 'package:red_flags/app/widgets/shakles/shakle_text.dart';
import 'dart:async';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<SplashScreen> with TickerProviderStateMixin {
  late final PageController _pageCtrl;

  final _splashscreenDur = Duration(milliseconds: 3000);
  final _swapTic = Duration(milliseconds: 400);

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController(initialPage: 0, viewportFraction: 0.6);
    _pageCtrl.addListener(() {
      if (_pageCtrl.page!.roundToDouble() == _pageCtrl.page && _pageCtrl.page! < 5) {
        _pageCtrl.animateToPage(_pageCtrl.page == null ? 0 : _pageCtrl.page!.toInt() + 1, duration: _swapTic, curve: Curves.easeInOut);
      }
    });

    Future.delayed(_splashscreenDur, () {
      if (!mounted) return;
      ref.read(routerNotifierprovider.notifier).pushAndRemoveUntil(Navigator.of(context), const HomeScreen());
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("Lets go");
      _pageCtrl.animateToPage(1, duration: _swapTic, curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final pagerHeight = MediaQuery.of(context).size.height / 3;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {},
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              SlideWidget(
                duration: Duration(milliseconds: 400),
                child: Center(child: ShakleText(AppLocalizations.of(context)!.title, style: Theme.of(context).textTheme.displayLarge)),
              ),
              // FadeWidget(
              //   duration: Duration(milliseconds: 400),
              //   child: Align(
              //     alignment: Alignment(0, 1),
              //     child: SizedBox(
              //       height: pagerHeight,
              //       child: PageView.builder(
              //         controller: _pageCtrl,
              //         physics: NeverScrollableScrollPhysics(),
              //         itemCount: 7,
              //         itemBuilder: (context, index) {
              //           if (index < 2) return SizedBox(width: screenWidth);
              //           if (index == 5) return Image.asset("assets/images/stickman_red.png", fit: BoxFit.contain);
              //           return SizedBox(width: double.infinity, child: Image.asset("assets/images/stickman_grey.png", fit: BoxFit.contain));
              //         },
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
