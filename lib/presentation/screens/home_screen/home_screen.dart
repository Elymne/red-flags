import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/presentation/router/router.notifier.dart';
import 'package:red_flags/presentation/screens/create_person_screen/create_person_screen.dart';
import 'package:red_flags/presentation/screens/search_screen/search_screen.dart';
import 'package:red_flags/presentation/widgets/backgrounds/waves_background.dart';
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
  @override
  void initState() {
    super.initState();
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
                    TitleContainer(
                      title: AppLocalizations.of(context)!.homeScreenTitle,
                      subtitle: AppLocalizations.of(context)!.homeScreenSubTitle,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    Expanded(child: SizedBox()),
                    SlideWidget(
                      duration: Duration(milliseconds: 200),
                      child: Row(
                        children: [
                          ShakleTextButton(
                            AppLocalizations.of(context)!.homeAddOption,
                            onPressed: () {
                              ref.read(routerNotifierprovider.notifier).push(Navigator.of(context), const CreatePersonScreen());
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    SlideWidget(
                      duration: Duration(milliseconds: 400),
                      child: ShakleTextButton(
                        AppLocalizations.of(context)!.homeSearchOption,
                        onPressed: () {
                          ref.read(routerNotifierprovider.notifier).push(Navigator.of(context), const SearchScreen());
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    SlideWidget(
                      duration: Duration(milliseconds: 600),
                      child: ShakleTextButton(AppLocalizations.of(context)!.homeNews, onPressed: () {}),
                    ),
                    SizedBox(height: 10),
                    SlideWidget(
                      duration: Duration(milliseconds: 800),
                      child: ShakleTextButton(AppLocalizations.of(context)!.homeOptions, onPressed: () {}),
                    ),
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
