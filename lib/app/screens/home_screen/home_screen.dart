import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/app/router/router.notifier.dart';
import 'package:red_flags/app/screens/create_person_screen/create_person_screen.dart';
import 'package:red_flags/app/widgets/backgrounds/waves_background.dart';
import 'package:red_flags/app/widgets/layouts/title_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:red_flags/app/widgets/routing/fade_widget.dart';
import 'package:red_flags/app/widgets/routing/slide_widget.dart';
import 'package:red_flags/app/widgets/shakles/shakle_home_item.dart';
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
                offset: Offset(width * 0.3, height * 0.6),
                child: WaveBackground(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            FadeWidget(
              duration: Duration(milliseconds: 1000),
              child: Transform.translate(
                offset: Offset(width * 0.3, height * 0.5),
                child: WaveBackground(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(screenGlobalMargin),
                child: Column(
                  children: [
                    TitleContainer(
                      title: AppLocalizations.of(context)!.homeScreenTitle,
                      subtitle: AppLocalizations.of(context)!.homeScreenSubTitle,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    Expanded(child: SizedBox()),
                    Expanded(
                      child: SlideWidget(
                        duration: Duration(milliseconds: 200),
                        child: ShakleHomeItem(
                          iconPath: "assets/icons/search.svg",
                          title: AppLocalizations.of(context)!.homeAddOption,
                          onTap: () {
                            ref.read(routerNotifierprovider.notifier).push(Navigator.of(context), const CreatePersonScreen());
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: SlideWidget(
                        duration: Duration(milliseconds: 400),
                        child: ShakleHomeItem(
                          iconPath: "assets/icons/search.svg",
                          title: AppLocalizations.of(context)!.homeSearchOption,
                          onTap: () {},
                        ),
                      ),
                    ),
                    SizedBox(height: 10),

                    Expanded(
                      child: SlideWidget(
                        duration: Duration(milliseconds: 600),
                        child: ShakleHomeItem(
                          iconPath: "assets/icons/search.svg",
                          title: AppLocalizations.of(context)!.homeNews,
                          onTap: () {},
                        ),
                      ),
                    ),
                    SizedBox(height: 10),

                    Expanded(
                      child: SlideWidget(
                        duration: Duration(milliseconds: 800),
                        child: ShakleHomeItem(
                          iconPath: "assets/icons/search.svg",
                          title: AppLocalizations.of(context)!.homeOptions,
                          onTap: () {},
                        ),
                      ),
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
