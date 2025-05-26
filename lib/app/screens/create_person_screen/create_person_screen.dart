import 'package:red_flags/app/router/router.notifier.dart';
import 'package:red_flags/app/screens/create_person_screen/widgets/form_widget_activity.dart';
import 'package:red_flags/app/screens/create_person_screen/widgets/form_widget_company.dart';
import 'package:red_flags/app/screens/create_person_screen/form/person_form_controller.dart';
import 'package:red_flags/app/screens/create_person_screen/widgets/form_widget_identity.dart';
import 'package:red_flags/app/screens/create_person_screen/widgets/form_widget_zone.dart';
import 'package:red_flags/app/screens/create_person_screen/states/activities_state.provider.dart';
import 'package:red_flags/app/screens/create_person_screen/states/companies_state.provider.dart';
import 'package:red_flags/app/screens/create_person_screen/states/create_person_result_state.provider.dart';
import 'package:red_flags/app/screens/create_person_screen/states/zones_state.provider.dart';
import 'package:red_flags/app/screens/home_screen/home_screen.dart';
import 'package:red_flags/app/widgets/layouts/title_container.dart';
import 'package:red_flags/app/widgets/routing/slide_widget.dart';
import 'package:red_flags/app/widgets/shakles/shakle_outlined_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:red_flags/core/states/widget_state.dart';
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
  late final _formCtrl = PersonFormController(formState);
  final formState = ValueNotifier<int>(0);
  int? dialog;

  @override
  Widget build(BuildContext context) {
    ref.listen(createPersonResultStateProvider, (_, next) async {
      if (next.status == WidgetStatus.success) {
        if (dialog != null) {
          Navigator.of(context).pop();
          dialog = null;
        }
        ref.read(routerNotifierprovider.notifier).push(Navigator.of(context), const HomeScreen());
        return;
      }

      if (next.status == WidgetStatus.loading) {
        if (dialog != null) {
          Navigator.of(context).pop();
          dialog = null;
        }
        dialog = await showDialog<int>(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(child: CircularProgressIndicator()),
        );
        return;
      }

      if (next.status == WidgetStatus.failure) {
        if (dialog != null) {
          Navigator.of(context).pop();
          dialog = null;
        }
        showDialog<void>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text(AppLocalizations.of(context)!.netFailure),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(AppLocalizations.of(context)!.backButton),
                  ),
                ],
              ),
        );
      }
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (_pageCtrl.page == 0) {
          ref.read(zonesStateProvider.notifier).reset();
          ref.read(activitiesStateProvider.notifier).reset();
          ref.read(companiesStateProvider.notifier).reset();
          ref.read(createPersonResultStateProvider.notifier).reset();
          ref.read(routerNotifierprovider.notifier).pop(Navigator.of(context));
          return;
        }
        _pageCtrl.animateToPage(_pageCtrl.page!.toInt() - 1, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
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
                ValueListenableBuilder<int>(
                  valueListenable: formState,
                  builder: (context, value, _) {
                    return SlideWidget(
                      duration: Duration(milliseconds: 1000),
                      child: Column(
                        children: [
                          Visibility(
                            /// *
                            visible: value == 0 || value == 1 && _pageCtrl.page == 1,
                            child: ShakleOutlinedButton("Next"),
                          ),
                          Visibility(
                            visible: value == 1 && _pageCtrl.page == 0 || value == 2 && _pageCtrl.page != 3,
                            child: ShakleOutlinedButton(
                              "Next",
                              onPressed: () {
                                _pageCtrl.animateToPage(
                                  _pageCtrl.page!.toInt() + 1,
                                  duration: Duration(milliseconds: 200),
                                  curve: Curves.easeIn,
                                );
                              },
                            ),
                          ),
                          Visibility(
                            visible: value == 2 && _pageCtrl.page == 3,
                            child: ShakleOutlinedButton(
                              "Create",
                              onPressed: () {
                                if (_pageCtrl.page == null) return;
                                ref.read(createPersonResultStateProvider.notifier).create(_formCtrl);
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
