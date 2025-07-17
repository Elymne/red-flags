import 'package:red_flags/domain/usecases/check_new_person_form.usecase.dart';
import 'package:red_flags/presentation/viewmodels/current_page.provider.dart';
import 'package:red_flags/presentation/viewmodels/new_person.provider.dart';
import 'package:red_flags/presentation/viewmodels/person_form.provider.dart';
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
  late final currentPageNotifier = ref.read(currentPageProvider.notifier);
  late final personFormNotifier = ref.read(personFormProvider.notifier);
  late final newPersonNotifier = ref.read(newPersonProvider.notifier);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final personForm = ref.watch(personFormProvider);

    return SingleChildScrollView(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SlideWidget(
              duration: Duration(milliseconds: 200),
              child: FormTextfield(
                icon: Icons.abc,
                label: "Nom",
                value: personFormNotifier.lastname ?? "",
                onSubmitted: (value) {
                  personFormNotifier.onFormUpdate(lastname: value);
                },
              ),
            ),
            Visibility(
              visible: personForm.data.contains(PersonFormInfo.tooShortLastname),
              child: Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Text("Too short", style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error)),
              ),
            ),

            SlideWidget(
              duration: Duration(milliseconds: 300),
              child: FormTextfield(
                icon: Icons.abc,
                label: "Prénom",
                value: personFormNotifier.firstname ?? "",
                onSubmitted: (value) {
                  personFormNotifier.onFormUpdate(firstname: value);
                },
              ),
            ),
            Visibility(
              visible: personForm.data.contains(PersonFormInfo.tooShortFirstname),
              child: Text("Too short", style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error)),
            ),

            SlideWidget(
              duration: Duration(milliseconds: 400),
              child: FormDatePicker(
                icon: Icons.date_range,
                label: "Date de Naissance",
                value: personFormNotifier.birthDate,
                onSubmitted: (value) {
                  personFormNotifier.onFormUpdate(birthDate: value);
                },
              ),
            ),
            Visibility(
              visible: personForm.data.contains(PersonFormInfo.tooYoung),
              child: Text("Too young", style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error)),
            ),

            SlideWidget(
              duration: Duration(milliseconds: 500),
              child: FormTextfieldButton(
                icon: Icons.location_city,
                label: "Région",
                value: personFormNotifier.zone?.name ?? "",
                onTap: () {
                  currentPageNotifier.setCurrentPage(1);
                },
              ),
            ),

            SlideWidget(
              duration: Duration(milliseconds: 600),
              child: FormTextfieldButton(
                icon: Icons.badge_sharp,
                label: "Société",
                value: personFormNotifier.company?.name ?? "",
                onTap: () {
                  currentPageNotifier.setCurrentPage(2);
                },
              ),
            ),

            SlideWidget(
              duration: Duration(milliseconds: 700),
              child: FormTextfieldButton(
                icon: Icons.local_activity,
                label: "Activité",
                value: personFormNotifier.activity?.name ?? "",
                onTap: () {
                  currentPageNotifier.setCurrentPage(3);
                },
              ),
            ),

            SizedBox(height: 40),
            Visibility(
              visible: personForm.data.isEmpty,
              child: SlideWidget(
                duration: Duration(milliseconds: 200),
                child: Align(
                  alignment: Alignment(0, -1),
                  child: OutlinedButton(
                    onPressed: () {
                      newPersonNotifier.add(
                        lastname: personFormNotifier.lastname!,
                        firstname: personFormNotifier.firstname!,
                        birthDate: personFormNotifier.birthDate!,
                        zoneID: personFormNotifier.zone!.id,
                        companyID: personFormNotifier.company!.id,
                        activityID: personFormNotifier.activity!.id,
                      );
                    },
                    child: Text(
                      "Créer",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
