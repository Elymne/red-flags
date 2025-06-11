import 'package:red_flags/core/reactive/reactive_state.dart';
import 'package:red_flags/presentation/viewmodels/activities.provider.dart';
import 'package:red_flags/presentation/viewmodels/person_form.provider.dart';
import 'package:red_flags/presentation/widgets/listviews/shakle_card.dart';
import 'package:red_flags/presentation/widgets/listviews/slide_list_view.dart';
import 'package:red_flags/presentation/widgets/routing/slide_widget.dart';
import 'package:red_flags/presentation/widgets/shakles/shakle_loading.dart';
import 'package:red_flags/presentation/widgets/shakles/shakle_textfield.dart';
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

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        SlideWidget(
          duration: Duration(milliseconds: 200),
          child: ShakleTextfield(
            AppLocalizations.of(context)!.activityName,
            onSubmitted: (value) {
              setState(() {
                personFormNotifier.resetActivity();
                activitiesNotifier.search(value);
              });
            },
          ),
        ),
        Visibility(
          visible: activitiesState.status == ReactiveStateStatus.success,
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Expanded(
              child: SlideListView(
                itemCount: activitiesState.data.length,
                itemBuilder: (_, index) {
                  final activity = activitiesState.data[index];
                  return ShakleCard(
                    text: activity.name,
                    icon: Icons.location_on,
                    isActive: activity.id == personFormNotifier.activity?.id,
                    onTap: () {
                      setState(() => personFormNotifier.onFormUpdate(activity: activity));
                    },
                  );
                },
              ),
            ),
          ),
        ),
        Visibility(
          visible: activitiesState.status == ReactiveStateStatus.loading,
          child: Padding(padding: EdgeInsets.only(top: 100), child: SizedBox(height: 40, width: 40, child: ShakleLoading())),
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
      ],
    );
  }
}
