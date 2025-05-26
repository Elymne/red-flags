import 'package:red_flags/app/screens/create_person_screen/form_controller/person_form_controller.dart';
import 'package:red_flags/app/widgets/routing/slide_widget.dart';
import 'package:red_flags/app/widgets/shakles/shakle_date_picker.dart';
import 'package:red_flags/app/widgets/shakles/shakle_textfield.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class FormIdentity extends ConsumerStatefulWidget {
  final PersonFormController formCtrl;

  const FormIdentity({super.key, required this.formCtrl});

  @override
  ConsumerState<FormIdentity> createState() => _State();
}

class _State extends ConsumerState<FormIdentity> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        SlideWidget(
          duration: Duration(milliseconds: 200),
          child: ShakleTextfield(
            AppLocalizations.of(context)!.firstname,
            value: widget.formCtrl.firstname,
            onChanged: (value) {
              setState(() {
                widget.formCtrl.updateValues(firstname: value);
              });
            },
          ),
        ),
        SizedBox(height: 20),
        SlideWidget(
          duration: Duration(milliseconds: 400),
          child: ShakleTextfield(
            AppLocalizations.of(context)!.lastname,
            value: widget.formCtrl.lastname,
            onChanged: (value) {
              setState(() {
                widget.formCtrl.updateValues(lastname: value);
              });
            },
          ),
        ),
        SizedBox(height: 20),
        SlideWidget(
          duration: Duration(milliseconds: 600),
          child: ShakleDatepicker(
            AppLocalizations.of(context)!.birthDate,
            selectedDate: widget.formCtrl.birthDate,
            onChanged: (value) => widget.formCtrl.updateValues(birthDate: value),
          ),
        ),
      ],
    );
  }
}
