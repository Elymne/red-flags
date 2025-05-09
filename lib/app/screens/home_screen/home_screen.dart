import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/app/router/router.notifier.dart';
import 'package:red_flags/app/screens/search_screen/search_screen.dart';
import 'package:red_flags/app/widgets/layouts/title_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:red_flags/app/widgets/page_change_related/slide_widget.dart';
import 'package:red_flags/app/widgets/shakles/shakle_home_item.dart';

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
      body: Column(
        children: [
          /// * Header container with page name.
          TitleContainer(title: AppLocalizations.of(context)!.homeScreenTitle, subtitle: AppLocalizations.of(context)!.homeScreenSubTitle),

          /// * Little margin.
          SizedBox(height: 20),

          /// * Add new Named Person.
          SlideWidget(
            duration: Duration(milliseconds: 200),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ShakleHomeItem(
                /// *
                "Create",
                animColor: Theme.of(context).colorScheme.primary,
                onTap: () {},
              ),
            ),
          ),

          /// * Search Named Person.
          SlideWidget(
            duration: Duration(milliseconds: 400),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ShakleHomeItem(
                /// *
                "Search",
                animColor: Theme.of(context).colorScheme.primary,
                onTap: () {
                  ref.read(routerNotifierprovider.notifier).changeScreen(() {
                    /// * Navigate.
                    final navigator = Navigator.of(context);
                    navigator.push(MaterialPageRoute(builder: (context) => const SearchScreen()));
                  });
                },
              ),
            ),
          ),

          /// * Search Unknown Named Person.
          SlideWidget(
            duration: Duration(milliseconds: 600),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ShakleHomeItem(
                /// *
                "Random Search",
                animColor: Theme.of(context).colorScheme.primary,
                isActive: false,
                onTap: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
