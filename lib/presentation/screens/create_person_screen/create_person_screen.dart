import 'dart:ui';
import 'package:red_flags/presentation/router/router.notifier.dart';
import 'package:red_flags/presentation/screens/create_person_screen/widgets/form_widget_activity.dart';
import 'package:red_flags/presentation/screens/create_person_screen/widgets/form_widget_company.dart';
import 'package:red_flags/presentation/screens/create_person_screen/person_form_state.dart';
import 'package:red_flags/presentation/screens/create_person_screen/widgets/form_widget_identity.dart';
import 'package:red_flags/presentation/screens/create_person_screen/widgets/form_widget_zone.dart';
import 'package:red_flags/presentation/viewmodels/activities.provider.dart';
import 'package:red_flags/presentation/viewmodels/companies.provider.dart';
import 'package:red_flags/presentation/viewmodels/new_person.provider.dart';
import 'package:red_flags/presentation/viewmodels/zones.provider.dart';
import 'package:red_flags/presentation/screens/home_screen/home_screen.dart';
import 'package:red_flags/presentation/widgets/layouts/title_container.dart';
import 'package:red_flags/presentation/widgets/routing/slide_widget.dart';
import 'package:red_flags/presentation/widgets/shakles/shakle_loading.dart';
import 'package:red_flags/presentation/widgets/shakles/shakle_text_button.dart';
import 'package:red_flags/core/l10n/app_localizations.dart';
import 'package:red_flags/core/states/reactive_state.dart';
import 'package:red_flags/core/themes/style_constant.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class CreatePersonScreen extends ConsumerStatefulWidget {
  const CreatePersonScreen({super.key});

  @override
  ConsumerState<CreatePersonScreen> createState() => _State();
}

class _State extends ConsumerState<CreatePersonScreen> {
  final formState = ValueNotifier(PersonFormButtonState(isFirstPageValid: false, isSecondPageValid: false));
  late final _pageCtrl = PageController(initialPage: 0)..addListener(() => setState(() {}));
  late final _formCtrl = PersonFormState(formState);
  bool isFreezing = false;

  @override
  Widget build(BuildContext context) {
    ref.listen(newPersonProvider, (_, next) async {
      if (next.status == DataStatus.success) {
        setState(() => isFreezing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.personCreationSuccess),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
        ref.read(zonesStateProvider.notifier).reset();
        ref.read(activitiesProvider.notifier).reset();
        ref.read(companiesProvider.notifier).reset();
        ref.read(newPersonProvider.notifier).reset();
        ref.read(routerNotifierprovider.notifier).pushAndRemoveUntil(Navigator.of(context), const HomeScreen());
        return;
      }

      if (next.status == DataStatus.failure) {
        setState(() => isFreezing = false);
        if (next.errorIndex == NewPersonState.networkError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.netFailure), backgroundColor: Theme.of(context).colorScheme.error),
          );
          return;
        }
        if (next.errorIndex == NewPersonState.userInputError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.personDuplicationError),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
          return;
        }
      }

      if (next.status == DataStatus.loading) {
        setState(() => isFreezing = true);
        return;
      }
    });

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
                        children: [
                          FormWidgetIdentity(formCtrl: _formCtrl),
                          FormWidgetZone(formCtrl: _formCtrl),
                          FormWidgetActivity(formCtrl: _formCtrl),
                          FormWidgetCompany(formCtrl: _formCtrl),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    ValueListenableBuilder(
                      valueListenable: formState,
                      builder: (context, value, _) {
                        return Align(
                          alignment: Alignment.centerRight,
                          child: SlideWidget(
                            duration: Duration(milliseconds: 1000),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Visibility(
                                  visible: _pageCtrl.page != null ? _pageCtrl.page!.toInt() > 0 : false,
                                  child: ShakleTextButton(
                                    AppLocalizations.of(context)!.previousButton,
                                    onPressed: () {
                                      if (_pageCtrl.page == null) return;
                                      _pageCtrl.animateToPage(
                                        _pageCtrl.page!.toInt() - 1,
                                        duration: Duration(milliseconds: 200),
                                        curve: Curves.easeIn,
                                      );
                                    },
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Visibility(
                                      visible: value.cannotNext(_pageCtrl.page == null ? 0 : _pageCtrl.page!.toInt()),
                                      child: ShakleTextButton(AppLocalizations.of(context)!.nextButton),
                                    ),
                                    Visibility(
                                      visible: value.canNext(_pageCtrl.page == null ? 0 : _pageCtrl.page!.toInt()),
                                      child: ShakleTextButton(
                                        AppLocalizations.of(context)!.nextButton,
                                        onPressed: () {
                                          if (_pageCtrl.page == null) return;
                                          _pageCtrl.animateToPage(
                                            _pageCtrl.page!.toInt() + 1,
                                            duration: Duration(milliseconds: 200),
                                            curve: Curves.easeIn,
                                          );
                                        },
                                      ),
                                    ),
                                    Visibility(
                                      visible: value.canCreate(_pageCtrl.page == null ? 0 : _pageCtrl.page!.toInt()),
                                      child: ShakleTextButton(
                                        AppLocalizations.of(context)!.createButton,
                                        onPressed: () {
                                          ref.read(newPersonProvider.notifier).create(_formCtrl);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            /// * Loading *
            if (isFreezing)
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(color: Theme.of(context).colorScheme.outline.withAlpha(100)),
              ),
            if (isFreezing) Center(child: ShakleLoading()),
          ],
        ),
      ),
    );
  }
}
