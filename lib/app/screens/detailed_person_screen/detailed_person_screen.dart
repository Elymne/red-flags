import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/app/router/router.notifier.dart';
import 'package:red_flags/app/screens/detailed_person_screen/detailed_person_screen_state.dart';
import 'package:red_flags/app/screens/home_screen/home_screen.dart';
import 'package:red_flags/app/widgets/layouts/title_container.dart';
import 'package:red_flags/app/widgets/page_change_related/shakle_pop_text.dart';
import 'package:red_flags/app/widgets/page_change_related/slide_widget.dart';
import 'package:red_flags/app/widgets/shakles/shakle_loading.dart';
import 'package:red_flags/app/widgets/shakles/shakle_outlined_button.dart';
import 'package:red_flags/app/widgets/shakles/shakle_text.dart';
import 'package:red_flags/app/widgets/shakles/shakle_text_button.dart';
import 'package:red_flags/core/extensions/string_extension.dart';
import 'package:red_flags/core/states/widget_state.dart';
import 'package:red_flags/core/themes/style_constant.dart';

class DetailedPersonScreen extends ConsumerStatefulWidget {
  final String id;

  const DetailedPersonScreen({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<DetailedPersonScreen> with TickerProviderStateMixin {
  late final PageController pageController;

  @override
  void initState() {
    super.initState();

    /// * Setup page controller.
    pageController = PageController(initialPage: 0, viewportFraction: 1);

    /// * Waiting for widget building.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      /// * Fetch details about the person.
      ref.read(detailedPersonScreenState.notifier).find(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    /// * Watching detailedPerson Provider state.
    final personProvider = ref.watch(detailedPersonScreenState);

    /// * On init, display nothing.
    if (personProvider.status == WidgetStatus.init) {
      return Scaffold(body: SizedBox());
    }

    /// * Display a loading weel.
    if (personProvider.status == WidgetStatus.loading) {
      return Expanded(child: Center(child: const ShakleLoading()));
    }

    /// * Display error message + backbutton on error.
    if (personProvider.status == WidgetStatus.failure) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SlideWidget(
                duration: Duration(milliseconds: 400),
                child: ShakleText(
                  AppLocalizations.of(context)!.applicationFailure,
                  style: Theme.of(context).textTheme.bodyLarge,
                  force: 0.4,
                ),
              ),
              SizedBox(height: 20),
              SlideWidget(
                duration: Duration(milliseconds: 800),
                child: ShakleOutlinedButton(
                  AppLocalizations.of(context)!.backButton,
                  onPressed: () {
                    /// * Back to home menu on error.
                    ref.read(routerNotifierprovider.notifier).changeScreen(() {
                      final navigator = Navigator.of(context);
                      navigator.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false);
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }

    /// * Normal display when data is loaded.
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(screenGlobalMargin),
        child: Column(
          children: [
            /// * Title component.
            TitleContainer(
              title: "${personProvider.detailedPerson!.firstName.toName()} ${personProvider.detailedPerson!.lastName.toName()}",
              subtitle: "${personProvider.detailedPerson!.zoneName.toName()} - ${personProvider.detailedPerson!.jobName.toName()}",
            ),

            /// * Space.
            SizedBox(height: 20),

            /// * Content component.
            Expanded(
              child: PageView(
                controller: pageController,
                children: [
                  /// * Resume.
                  Container(color: const Color.fromARGB(255, 180, 107, 102)),

                  /// * ListView Articles.
                  Container(color: const Color.fromARGB(255, 99, 219, 203)),

                  /// * Description Bloc.
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShaklePopText(
                        AppLocalizations.of(context)!.descriptionTitle,
                        style: Theme.of(context).textTheme.titleLarge,
                        hasIdleAnim: false,
                        force: 0.4,
                        speedAnimation: Duration(milliseconds: 10),
                      ),
                      SizedBox(height: 10),
                      ShaklePopText(
                        personProvider.detailedPerson!.description!,
                        style: Theme.of(context).textTheme.bodyLarge,
                        hasIdleAnim: false,
                        force: 0.4,
                        speedAnimation: Duration(milliseconds: 10),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// * Pager button management.
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShakleTextButton("Description", onPressed: () {}),
                ShakleTextButton("Description", onPressed: () {}),
                ShakleTextButton("Description", onPressed: () {}),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
