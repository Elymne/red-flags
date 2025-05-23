import 'package:red_flags/app/router/router.notifier.dart';
import 'package:red_flags/app/screens/create_person_screen/form_controller/create_person_form_controller.dart';
import 'package:red_flags/app/screens/create_person_screen/form_identity.dart';
import 'package:red_flags/app/screens/create_person_screen/form_zone.dart';
import 'package:red_flags/app/screens/create_person_screen/states/zones_state.dart';
import 'package:red_flags/app/widgets/layouts/title_container.dart';
import 'package:red_flags/app/widgets/routing/slide_widget.dart';
import 'package:red_flags/app/widgets/shakles/shakle_outlined_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:red_flags/core/themes/style_constant.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class CreatePersonScreen extends ConsumerStatefulWidget {
  const CreatePersonScreen({super.key});

  @override
  ConsumerState<CreatePersonScreen> createState() => _State();
}

class _State extends ConsumerState<CreatePersonScreen> {
  late final _pageCtrl = PageController(initialPage: 0);
  late final _formCtrl = CreatePersonFormController(formState);
  final formState = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (_pageCtrl.page == 0) {
          ref.read(zonesStateProvider.notifier).reset();
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
                    children: [FormIdentity(formCtrl: _formCtrl), FormZone(formCtrl: _formCtrl)],
                  ),
                ),
                ValueListenableBuilder<int>(
                  valueListenable: formState,
                  builder: (context, value, _) {
                    return SlideWidget(
                      duration: Duration(milliseconds: 1000),
                      child: Column(
                        children: [
                          Visibility(visible: value == 0, child: ShakleOutlinedButton("Next")),
                          Visibility(
                            visible: value == 1,
                            child: ShakleOutlinedButton(
                              "Next",
                              onPressed: () {
                                _pageCtrl.animateToPage(1, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                              },
                            ),
                          ),
                          Visibility(
                            visible: value == 2 && _pageCtrl.page != 4,
                            child: ShakleOutlinedButton(
                              "Next",
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
                            visible: value == 2 && _pageCtrl.page == 4,
                            child: ShakleOutlinedButton(
                              "Create",
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
