import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/app/router/router.notifier.dart';
import 'package:red_flags/app/screens/create_person_screen/create_person_screen.dart';
import 'package:red_flags/app/screens/search_screen/search_screen.dart';
import 'package:red_flags/app/widgets/layouts/title_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:red_flags/app/widgets/page_change_related/slide_widget.dart';
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(screenGlobalMargin),
        child: Column(
          children: [
            /// * Header container with page name.
            TitleContainer(
              title: AppLocalizations.of(context)!.homeScreenTitle,
              subtitle: AppLocalizations.of(context)!.homeScreenSubTitle,
            ),

            /// * Spacer.
            Expanded(child: SizedBox()),

            /// * Add person to database.
            SlideWidget(
              duration: Duration(milliseconds: 200),
              child: ShakleHomeItem(
                /// *
                iconData: Icons.add_outlined,
                title: AppLocalizations.of(context)!.homeAddOption,
                onTap: () {
                  ref.read(routerNotifierprovider.notifier).changeScreen(() {
                    /// * Navigate.
                    final navigator = Navigator.of(context);
                    navigator.push(MaterialPageRoute(builder: (context) => const CreatePersonScreen()));
                  });
                },
              ),
            ),

            /// * Spacer
            SizedBox(height: 10),

            /// * Search Named Person.
            SlideWidget(
              duration: Duration(milliseconds: 400),
              child: ShakleHomeItem(
                /// *
                iconData: Icons.search_outlined,
                title: AppLocalizations.of(context)!.homeSearchOption,
                onTap: () {
                  ref.read(routerNotifierprovider.notifier).changeScreen(() {
                    /// * Navigate.
                    final navigator = Navigator.of(context);
                    navigator.push(MaterialPageRoute(builder: (context) => const SearchScreen()));
                  });
                },
              ),
            ),

            /// * Spacer
            SizedBox(height: 10),

            /// * Search Unknown Named Person.
            SlideWidget(
              duration: Duration(milliseconds: 600),
              child: ShakleHomeItem(
                /// *
                iconData: Icons.perm_camera_mic_outlined,
                title: "News",
                isActive: false,
                onTap: () {},
              ),
            ),

            /// * Spacer.
            Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
