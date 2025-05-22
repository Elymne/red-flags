import 'package:red_flags/app/router/router.notifier.dart';
import 'package:red_flags/app/screens/create_person_screen/create_person_screen.dart';
import 'package:red_flags/app/widgets/routing/slide_widget.dart';
import 'package:red_flags/app/widgets/shakles/shakle_date_picker.dart';
import 'package:red_flags/app/widgets/shakles/shakle_textfield.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:red_flags/core/themes/style_constant.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class PageBasicInformation extends ConsumerStatefulWidget {
  final CreatePersonFormController formController;

  const PageBasicInformation({super.key, required this.formController});

  @override
  ConsumerState<PageBasicInformation> createState() => _State();
}

class _State extends ConsumerState<PageBasicInformation> {
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
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SlideWidget(
                  duration: Duration(milliseconds: 200),
                  child: ShakleTextfield(
                    AppLocalizations.of(context)!.firstname,
                    onChanged: (value) {
                      widget.formController.updateValues(firstname: value);
                    },
                  ),
                ),
                SizedBox(height: 20),
                SlideWidget(
                  duration: Duration(milliseconds: 400),
                  child: ShakleTextfield(
                    AppLocalizations.of(context)!.lastname,
                    onChanged: (value) {
                      widget.formController.updateValues(lastname: value);
                    },
                  ),
                ),
                SizedBox(height: 20),
                SlideWidget(
                  duration: Duration(milliseconds: 600),
                  child: ShakleDatepicker(
                    AppLocalizations.of(context)!.birthDate,
                    onChanged: (value) {
                      widget.formController.updateValues(birthDate: value);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
