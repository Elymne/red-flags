import 'package:red_flags/presentation/viewmodels/person_form.provider.dart';
import 'package:red_flags/presentation/widgets/routing/slide_widget.dart';
import 'package:red_flags/presentation/widgets/shakles/shakle_date_picker.dart';
import 'package:red_flags/presentation/widgets/shakles/shakle_textfield.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:red_flags/core/l10n/app_localizations.dart';

class FormWidgetIdentity extends ConsumerStatefulWidget {
  const FormWidgetIdentity({super.key});

  @override
  ConsumerState<FormWidgetIdentity> createState() => _State();
}

class _State extends ConsumerState<FormWidgetIdentity> {
  @override
  Widget build(BuildContext context) {
    final personFormNotifier = ref.read(personFormProvider.notifier);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        SlideWidget(
          duration: Duration(milliseconds: 200),
          child: ShakleTextfield(
            AppLocalizations.of(context)!.firstname,
            value: personFormNotifier.firstname,
            icon: Icons.person_2_outlined,
            onChanged: (value) {
              personFormNotifier.onFormUpdate(firstname: value);
            },
          ),
        ),
        SizedBox(height: 20),
        SlideWidget(
          duration: Duration(milliseconds: 400),
          child: ShakleTextfield(
            AppLocalizations.of(context)!.lastname,
            value: personFormNotifier.lastname,
            icon: Icons.person_2_outlined,
            onChanged: (value) {
              personFormNotifier.onFormUpdate(lastname: value);
            },
          ),
        ),
        SizedBox(height: 20),
        SlideWidget(
          duration: Duration(milliseconds: 600),
          child: ShakleDatepicker(
            AppLocalizations.of(context)!.birthDate,
            selectedDate: personFormNotifier.birthDate,
            onChanged: (value) {
              personFormNotifier.onFormUpdate(birthDate: value);
            },
          ),
        ),
      ],
    );
  }
}
