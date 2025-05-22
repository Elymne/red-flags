import 'package:red_flags/app/router/router.notifier.dart';
import 'package:red_flags/app/widgets/routing/slide_widget.dart';
import 'package:red_flags/app/widgets/layouts/title_container.dart';
import 'package:red_flags/app/widgets/shakles/shakle_date_picker.dart';
import 'package:red_flags/app/widgets/shakles/shakle_outlined_button.dart';
import 'package:red_flags/app/widgets/shakles/shakle_textfield.dart';
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
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,

      onPopInvokedWithResult: (didPop, result) {
        ref.read(routerNotifierprovider.notifier).pop(Navigator.of(context));
      },
      child: Scaffold(
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
                Expanded(child: SizedBox()),
                SlideWidget(
                  duration: Duration(milliseconds: 200),
                  child: ShakleTextfield("${AppLocalizations.of(context)!.firstname}*", onChanged: (value) {}),
                ),
                SizedBox(height: 20),
                SlideWidget(
                  duration: Duration(milliseconds: 400),
                  child: ShakleTextfield("${AppLocalizations.of(context)!.lastname}*", onChanged: (value) {}),
                ),
                SizedBox(height: 20),
                SlideWidget(
                  duration: Duration(milliseconds: 600),
                  child: ShakleDatepicker("${AppLocalizations.of(context)!.birthDate}*", onChanged: (value) {}),
                ),
                Expanded(child: SizedBox()),
                SlideWidget(
                  duration: Duration(milliseconds: 1400),
                  child: Visibility(
                    visible: false,
                    child: Align(
                      alignment: Alignment.center,
                      child: ShakleOutlinedButton(AppLocalizations.of(context)!.createButton, isActive: true, onPressed: () {}),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
