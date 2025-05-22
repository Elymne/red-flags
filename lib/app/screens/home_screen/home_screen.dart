import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/app/router/router.notifier.dart';
import 'package:red_flags/app/screens/create_person_screen/create_person_screen.dart';
import 'package:red_flags/app/widgets/layouts/title_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:red_flags/app/widgets/routing/slide_widget.dart';
import 'package:red_flags/app/widgets/shakles/shakle_home_item.dart';
import 'package:red_flags/core/themes/style_constant.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<HomeScreen> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {},
      child: Scaffold(
        body: SafeArea(
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
                SlideWidget(
                  duration: Duration(milliseconds: 200),
                  child: ShakleHomeItem(
                    iconData: Icons.add_outlined,
                    title: AppLocalizations.of(context)!.homeAddOption,
                    onTap: () {
                      ref.read(routerNotifierprovider.notifier).push(Navigator.of(context), const CreatePersonScreen());
                    },
                  ),
                ),
                SizedBox(height: 10),
                SlideWidget(
                  duration: Duration(milliseconds: 400),
                  child: ShakleHomeItem(
                    iconData: Icons.search_outlined,
                    title: AppLocalizations.of(context)!.homeSearchOption,
                    onTap: () {},
                  ),
                ),
                SizedBox(height: 10),
                SlideWidget(
                  duration: Duration(milliseconds: 600),
                  child: ShakleHomeItem(iconData: Icons.perm_camera_mic_outlined, title: "News", isActive: false, onTap: () {}),
                ),
                Expanded(child: SizedBox()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
