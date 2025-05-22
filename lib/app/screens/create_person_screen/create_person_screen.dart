import 'dart:async';

import 'package:red_flags/app/router/router.notifier.dart';
import 'package:red_flags/app/screens/create_person_screen/page_basic_information.dart';
import 'package:red_flags/app/widgets/layouts/title_container.dart';
import 'package:red_flags/app/widgets/shakles/shakle_outlined_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:red_flags/core/themes/style_constant.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:red_flags/models/activity.model.dart';
import 'package:red_flags/models/company.model.dart';

class CreatePersonScreen extends ConsumerStatefulWidget {
  const CreatePersonScreen({super.key});

  @override
  ConsumerState<CreatePersonScreen> createState() => _State();
}

class _State extends ConsumerState<CreatePersonScreen> {
  late final pageController = PageController(initialPage: 1);
  late final formController = CreatePersonFormController(formState);
  final formState = ValueNotifier<int>(0x00);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        ref.read(routerNotifierprovider.notifier).pop(Navigator.of(context));
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
                SizedBox(height: 20),
                Expanded(
                  child: PageView(
                    controller: pageController,
                    children: [
                      /// *
                      PageBasicInformation(formController: formController),
                    ],
                  ),
                ),
                ValueListenableBuilder<int>(
                  valueListenable: formState,
                  builder: (context, value, _) {
                    return Column(
                      children: [
                        Visibility(
                          /// *
                          visible: value == 0x00,
                          child: ShakleOutlinedButton("Next", isActive: false, onPressed: () {}),
                        ),
                        Visibility(
                          /// *
                          visible: value == 0x10,
                          child: ShakleOutlinedButton(
                            "Next",
                            onPressed: () {
                              pageController.animateToPage(2, duration: Duration(milliseconds: 400), curve: Curves.bounceIn);
                            },
                          ),
                        ),
                        Visibility(
                          /// *
                          visible: value == 0x11,
                          child: ShakleOutlinedButton(
                            "Next",
                            onPressed: () {
                              if (pageController.page == null) return;
                              pageController.animateToPage(
                                pageController.page!.toInt() + 1,
                                duration: Duration(milliseconds: 400),
                                curve: Curves.bounceIn,
                              );
                            },
                          ),
                        ),
                      ],
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

class CreatePersonFormController {
  /// * Simple int flag.
  final ValueNotifier<int> state;
  String _firstname = "";
  String _lastname = "";
  DateTime? _birthDate;
  Zone? _zone;
  Activity? _activity;
  Company? _company;

  CreatePersonFormController(this.state);

  void updateValues({String? firstname, String? lastname, DateTime? birthDate, Zone? zone, Activity? activity, Company? company}) {
    _firstname = firstname ?? _firstname;
    _lastname = lastname ?? _lastname;
    _birthDate = birthDate ?? _birthDate;
    _zone = zone ?? _zone;
    _activity = activity ?? _activity;
    _company = company ?? _company;

    if (_firstname.length < 2 || _lastname.length < 2 || _birthDate == null) {
      state.value = 0x00;
      return;
    }

    if (_zone == null) {
      state.value = 0x10;
      return;
    }

    state.value = 0x11;
  }
}
