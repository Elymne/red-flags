import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/presentation/router/router.notifier.dart';
import 'package:red_flags/presentation/screens/create_person_screen/create_person_screen.dart';
import 'package:red_flags/presentation/viewmodels/current_screen.provider.dart';
import 'package:red_flags/presentation/widgets/backgrounds/waves_background.dart';
import 'package:red_flags/presentation/widgets/layouts/bottom_nav.dart';
import 'package:red_flags/presentation/widgets/layouts/title_container.dart';
import 'package:red_flags/presentation/widgets/routing/fade_widget.dart';
import 'package:red_flags/presentation/widgets/routing/slide_widget.dart';
import 'package:red_flags/presentation/widgets/shakles/shakle_text_button.dart';
import 'package:red_flags/core/l10n/app_localizations.dart';
import 'package:red_flags/core/themes/style_constant.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<HomeScreen> {
  late final currentScreenNotifier = ref.read(currentScreenProvider.notifier);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      currentScreenNotifier.updateCurrentScreen(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {},
      child: Scaffold(
        bottomNavigationBar: BottomNav(),
        body: Stack(
          children: [
            FadeWidget(
              duration: Duration(milliseconds: 1000),
              child: Transform.translate(
                offset: Offset(width * 0.9, height * 0.8),
                child: WaveBackground(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            FadeWidget(
              duration: Duration(milliseconds: 1000),
              child: Transform.translate(
                offset: Offset(width * 0.8, height * 0.7),
                child: WaveBackground(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(screenGlobalMargin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleContainer(title: AppLocalizations.of(context)!.homeScreenTitle, color: Theme.of(context).colorScheme.primary),
                    Expanded(child: SizedBox()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
