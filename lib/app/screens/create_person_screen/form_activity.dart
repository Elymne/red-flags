import 'package:red_flags/app/screens/create_person_screen/form_controller/create_person_form_controller.dart';
import 'package:red_flags/app/screens/create_person_screen/states/activities_state.provider.dart';
import 'package:red_flags/app/widgets/listviews/card_single_line.dart';
import 'package:red_flags/app/widgets/listviews/slide_list_view.dart';
import 'package:red_flags/app/widgets/routing/slide_widget.dart';
import 'package:red_flags/app/widgets/shakles/shakle_loading.dart';
import 'package:red_flags/app/widgets/shakles/shakle_textfield.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:red_flags/core/states/widget_state.dart';

class FormActivity extends ConsumerStatefulWidget {
  final CreatePersonFormController formCtrl;

  const FormActivity({super.key, required this.formCtrl});

  @override
  ConsumerState<FormActivity> createState() => _State();
}

class _State extends ConsumerState<FormActivity> {
  @override
  Widget build(BuildContext context) {
    final activitiesState = ref.watch(activitiesStateProvider);

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
                widget.formCtrl.resetActivity();
                ref.read(activitiesStateProvider.notifier).search(value);
              });
            },
          ),
        ),
        SizedBox(height: 20),
        Visibility(
          visible: activitiesState.status == WidgetStatus.success,
          child: Expanded(
            child: SlideListView(
              itemCount: activitiesState.activities.length,
              itemBuilder: (_, index) {
                final activity = activitiesState.activities[index];
                return CardSingleLine(
                  text: activity.name,
                  icon: Icons.location_on,
                  isActive: activity.id == widget.formCtrl.activity?.id,
                  onTap: () {
                    setState(() => widget.formCtrl.updateValues(activity: activity));
                  },
                );
              },
            ),
          ),
        ),
        Visibility(
          visible: activitiesState.status == WidgetStatus.loading,
          child: Padding(padding: EdgeInsets.only(top: 100), child: SizedBox(height: 40, width: 40, child: ShakleLoading())),
        ),
      ],
    );
  }
}
