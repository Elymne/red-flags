import 'package:red_flags/core/reactive/reactive_state.dart';
import 'package:red_flags/presentation/viewmodels/activities.provider.dart';
import 'package:red_flags/presentation/viewmodels/current_page.provider.dart';
import 'package:red_flags/presentation/viewmodels/person_form.provider.dart';
import 'package:red_flags/presentation/widgets/forms/form_textfield.dart';
import 'package:red_flags/presentation/widgets/listviews/card_single.dart';
import 'package:red_flags/presentation/widgets/listviews/slide_list_view.dart';
import 'package:red_flags/presentation/widgets/routing/slide_widget.dart';
import 'package:red_flags/presentation/widgets/routing/title_pop_text.dart';
import 'package:red_flags/presentation/widgets/shakles/shakle_loading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:red_flags/core/l10n/app_localizations.dart';

class FormWidgetActivity extends ConsumerStatefulWidget {
  const FormWidgetActivity({super.key});

  @override
  ConsumerState<FormWidgetActivity> createState() => _State();
}

class _State extends ConsumerState<FormWidgetActivity> {
  @override
  Widget build(BuildContext context) {
    final personFormNotifier = ref.read(personFormProvider.notifier);
    final activitiesNotifier = ref.read(activitiesProvider.notifier);
    final activitiesState = ref.watch(activitiesProvider);
    final currentPageNotifier = ref.read(currentPageProvider.notifier);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitlePopText(
          "Sélectionner l'activité en cours :",
          animTic: Duration(milliseconds: 40),
          style: Theme.of(context).textTheme.headlineMedium,
          hasIdleAnim: true,
          color: Theme.of(context).colorScheme.primary,
        ),

        SizedBox(height: 20),

        FormTextfield(
          icon: Icons.search,
          label: AppLocalizations.of(context)!.searchButton,
          value: "",
          onSubmitted: (value) {
            activitiesNotifier.search(value);
          },
        ),

        Visibility(
          visible: activitiesState.status == ReactiveStateStatus.success && activitiesState.data.isNotEmpty,
          child: Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: SlideListView(
                itemCount: activitiesState.data.length,
                itemBuilder: (_, index) {
                  final activity = activitiesState.data[index];
                  return CardSingle(
                    text: activity.name,
                    icon: Icons.location_on,
                    onTap: () {
                      personFormNotifier.onFormUpdate(activity: activity);
                      currentPageNotifier.setCurrentPage(0);
                      activitiesNotifier.reset();
                    },
                  );
                },
              ),
            ),
          ),
        ),

        Visibility(
          visible: activitiesState.status == ReactiveStateStatus.success && activitiesState.data.isEmpty,
          child: Expanded(child: Center(child: Padding(padding: const EdgeInsets.only(top: 20), child: Text("Empty list")))),
        ),

        Visibility(
          visible: activitiesState.status == ReactiveStateStatus.loading,
          child: Expanded(child: Center(child: SizedBox(height: 40, width: 40, child: ShakleLoading()))),
        ),

        Visibility(
          visible: activitiesState.status == ReactiveStateStatus.failure,
          child: Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Text(
              AppLocalizations.of(context)!.errorNetwork,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ),

        Visibility(visible: activitiesState.status == ReactiveStateStatus.inactive, child: Expanded(child: SizedBox())),

        Align(
          alignment: Alignment(0, -1),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SlideWidget(
              duration: Duration(milliseconds: 200),
              child: OutlinedButton(
                onPressed: () {
                  currentPageNotifier.setCurrentPage(0);
                  activitiesNotifier.reset();
                },
                child: Text(
                  "Retour",
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.primary),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
