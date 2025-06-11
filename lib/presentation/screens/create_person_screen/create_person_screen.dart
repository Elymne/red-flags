import 'package:red_flags/presentation/router/router.notifier.dart';
import 'package:red_flags/presentation/screens/create_person_screen/form_widget_activity.dart';
import 'package:red_flags/presentation/screens/create_person_screen/form_widget_company.dart';
import 'package:red_flags/presentation/screens/create_person_screen/form_widget_identity.dart';
import 'package:red_flags/presentation/screens/create_person_screen/form_widget_zone.dart';
import 'package:red_flags/presentation/viewmodels/activities.provider.dart';
import 'package:red_flags/presentation/viewmodels/companies.provider.dart';
import 'package:red_flags/presentation/viewmodels/new_person.provider.dart';
import 'package:red_flags/presentation/viewmodels/zones.provider.dart';
import 'package:red_flags/presentation/widgets/layouts/title_container.dart';
import 'package:red_flags/core/l10n/app_localizations.dart';
import 'package:red_flags/core/themes/style_constant.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class CreatePersonScreen extends ConsumerStatefulWidget {
  const CreatePersonScreen({super.key});

  @override
  ConsumerState<CreatePersonScreen> createState() => _State();
}

class _State extends ConsumerState<CreatePersonScreen> {
  late final _pageCtrl = PageController(initialPage: 0)..addListener(() => setState(() {}));

  @override
  Widget build(BuildContext context) {
    // ref.listen(newPersonProvider, (_, next) async {
    //   if (next.status == ReactiveStateStatus.success) {
    //     setState(() => isFreezing = false);
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text(AppLocalizations.of(context)!.personCreationSuccess),
    //         backgroundColor: Theme.of(context).colorScheme.primary,
    //       ),
    //     );
    //     ref.read(zonesStateProvider.notifier).reset();
    //     ref.read(activitiesProvider.notifier).reset();
    //     ref.read(companiesProvider.notifier).reset();
    //     ref.read(newPersonProvider.notifier).reset();
    //     ref.read(routerNotifierprovider.notifier).pushAndRemoveUntil(Navigator.of(context), const HomeScreen());
    //     return;
    //   }

    //   if (next.status == DataStatus.failure) {
    //     setState(() => isFreezing = false);
    //     if (next.errorIndex == NewPersonState.networkError) {
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(content: Text(AppLocalizations.of(context)!.netFailure), backgroundColor: Theme.of(context).colorScheme.error),
    //       );
    //       return;
    //     }
    //     if (next.errorIndex == NewPersonState.userInputError) {
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(
    //           content: Text(AppLocalizations.of(context)!.personDuplicationError),
    //           backgroundColor: Theme.of(context).colorScheme.error,
    //         ),
    //       );
    //       return;
    //     }
    //   }

    //   if (next.status == DataStatus.loading) {
    //     setState(() => isFreezing = true);
    //     return;
    //   }
    // });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (_pageCtrl.page == 0) {
          ref.read(zonesStateProvider.notifier).reset();
          ref.read(activitiesProvider.notifier).reset();
          ref.read(companiesProvider.notifier).reset();
          ref.read(newPersonProvider.notifier).reset();
          ref.read(routerNotifierprovider.notifier).pop(Navigator.of(context));
          return;
        }

        _pageCtrl.animateToPage(_pageCtrl.page!.toInt() - 1, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(screenGlobalMargin),
                child: Column(
                  children: [
                    TitleContainer(
                      title: AppLocalizations.of(context)!.createScreenTitle,
                      subtitle: AppLocalizations.of(context)!.createScreenSubTitle,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    SizedBox(height: 40),
                    Expanded(
                      child: PageView(
                        controller: _pageCtrl,
                        physics: NeverScrollableScrollPhysics(),
                        children: [FormWidgetIdentity(), FormWidgetZone(), FormWidgetActivity(), FormWidgetCompany()],
                      ),
                    ),
                    SizedBox(height: 40),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            /// * Loading *
            // if (isFreezing)
            //   BackdropFilter(
            //     filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            //     child: Container(color: Theme.of(context).colorScheme.outline.withAlpha(100)),
            //   ),
            // if (isFreezing) Center(child: ShakleLoading()),
          ],
        ),
      ),
    );
  }
}
