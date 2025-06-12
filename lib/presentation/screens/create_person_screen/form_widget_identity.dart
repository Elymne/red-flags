import 'package:red_flags/presentation/viewmodels/person_form.provider.dart';
import 'package:red_flags/presentation/widgets/forms/form_button.dart';
import 'package:red_flags/presentation/widgets/forms/form_date_picker.dart';
import 'package:red_flags/presentation/widgets/forms/form_textfield.dart';
import 'package:red_flags/presentation/widgets/forms/form_textfield_button.dart';
import 'package:red_flags/presentation/widgets/routing/slide_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

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
          child: FormTextfield(icon: Icons.abc, label: "Nom", value: "", onSubmitted: (value) {}),
        ),
        SlideWidget(
          duration: Duration(milliseconds: 400),
          child: FormTextfield(icon: Icons.abc, label: "Prénom", value: "", onSubmitted: (value) {}),
        ),
        SlideWidget(
          duration: Duration(milliseconds: 600),
          child: FormDatePicker(icon: Icons.abc, label: "Date de Naissance", onSubmitted: (value) {}),
        ),
        SlideWidget(
          duration: Duration(milliseconds: 800),
          child: FormTextfieldButton(icon: Icons.abc, label: "Région", value: "", onSubmitted: (value) {}),
        ),
        SlideWidget(
          duration: Duration(milliseconds: 1000),
          child: FormTextfieldButton(icon: Icons.abc, label: "Nom", value: "", onSubmitted: (value) {}),
        ),
        SizedBox(height: 20),
        SlideWidget(duration: Duration(milliseconds: 1200), child: FormButton(onPressed: () {}, text: "Créer")),
        SizedBox(height: 20),
      ],
    );
  }
}
