import 'dart:ui';

import 'package:red_flags/core/reactive/reactive_state.dart';
import 'package:red_flags/presentation/router/router.notifier.dart';
import 'package:red_flags/presentation/screens/create_person_screen/form_widget_activity.dart';
import 'package:red_flags/presentation/screens/create_person_screen/form_widget_company.dart';
import 'package:red_flags/presentation/screens/create_person_screen/form_widget_identity.dart';
import 'package:red_flags/presentation/screens/create_person_screen/form_widget_zone.dart';
import 'package:red_flags/presentation/screens/home_screen/home_screen.dart';
import 'package:red_flags/presentation/viewmodels/current_page.provider.dart';
import 'package:red_flags/presentation/viewmodels/new_person.provider.dart';
import 'package:red_flags/presentation/viewmodels/person_form.provider.dart';
import 'package:red_flags/presentation/widgets/layouts/title_container.dart';
import 'package:red_flags/core/l10n/app_localizations.dart';
import 'package:red_flags/core/themes/style_constant.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:red_flags/presentation/widgets/shakles/shakle_loading.dart';

class CreatePersonScreen extends ConsumerStatefulWidget {
  const CreatePersonScreen({super.key});

  @override
  ConsumerState<CreatePersonScreen> createState() => _State();
}

class _State extends ConsumerState<CreatePersonScreen> {
  late final _pageCtrl = PageController(initialPage: 0)..addListener(() => setState(() {}));
  late final currentPageNotifier = ref.read(currentPageProvider.notifier);
  late final routerNotifier = ref.read(routerNotifierprovider.notifier);
  late final newPersonNotifier = ref.read(newPersonProvider.notifier);
  late final personFormNotifier = ref.read(personFormProvider.notifier);

  @override
  Widget build(BuildContext context) {
    ref.listen(currentPageProvider, (_, next) {
      _pageCtrl.animateToPage(next.data, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
    });

    ref.listen(newPersonProvider, (_, next) async {
      if (next.status == ReactiveStateStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.personCreationSuccess),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
        ref.read(routerNotifierprovider.notifier).pushAndRemoveUntil(Navigator.of(context), const HomeScreen());
        return;
      }

      if (next.status == ReactiveStateStatus.failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.errorNetwork), backgroundColor: Theme.of(context).colorScheme.error),
        );
      }
    });

    final newPersonWatcher = ref.watch(newPersonProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (_pageCtrl.page == 0) {
          newPersonNotifier.reset();
          personFormNotifier.reset();
          routerNotifier.pop(Navigator.of(context));
          return;
        }
        currentPageNotifier.setCurrentPage(0);
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
                    TitleContainer(title: AppLocalizations.of(context)!.createScreenTitle, color: Theme.of(context).colorScheme.primary),
                    Expanded(
                      child: PageView(
                        controller: _pageCtrl,
                        physics: NeverScrollableScrollPhysics(),
                        children: [FormWidgetIdentity(), FormWidgetZone(), FormWidgetCompany(), FormWidgetActivity()],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (newPersonWatcher.status == ReactiveStateStatus.loading)
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(color: Theme.of(context).colorScheme.outline.withAlpha(100)),
              ),
            if (newPersonWatcher.status == ReactiveStateStatus.loading) Center(child: ShakleLoading()),
          ],
        ),
      ),
    );
  }
}
