import 'package:red_flags/presentation/screens/create_person_screen/person_form_state.dart';
import 'package:red_flags/presentation/viewmodels/zones.provider.dart';
import 'package:red_flags/presentation/widgets/listviews/shakle_card.dart';
import 'package:red_flags/presentation/widgets/listviews/slide_list_view.dart';
import 'package:red_flags/presentation/widgets/routing/slide_widget.dart';
import 'package:red_flags/presentation/widgets/shakles/shakle_loading.dart';
import 'package:red_flags/presentation/widgets/shakles/shakle_textfield.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:red_flags/core/l10n/app_localizations.dart';
import 'package:red_flags/core/states/reactive_state.dart';

class FormWidgetZone extends ConsumerStatefulWidget {
  final PersonFormState formCtrl;

  const FormWidgetZone({super.key, required this.formCtrl});

  @override
  ConsumerState<FormWidgetZone> createState() => _State();
}

class _State extends ConsumerState<FormWidgetZone> {
  @override
  Widget build(BuildContext context) {
    final zonesState = ref.watch(zonesStateProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        SlideWidget(
          duration: Duration(milliseconds: 200),
          child: ShakleTextfield(
            AppLocalizations.of(context)!.zoneName,
            onSubmitted: (value) {
              setState(() {
                widget.formCtrl.resetZone();
                ref.read(zonesStateProvider.notifier).search(value);
              });
            },
          ),
        ),
        SizedBox(height: 20),
        Visibility(
          visible: zonesState.status == DataStatus.success,
          child: Expanded(
            child: SlideListView(
              itemCount: zonesState.zones.length,
              itemBuilder: (_, index) {
                final zone = zonesState.zones[index];
                return ShakleCard(
                  text: zone.name,
                  icon: Icons.location_on,
                  isActive: zone.id == widget.formCtrl.zone?.id,
                  onTap: () {
                    setState(() {
                      widget.formCtrl.updateValues(zone: zone);
                    });
                  },
                );
              },
            ),
          ),
        ),
        Visibility(
          visible: zonesState.status == DataStatus.loading,
          child: Padding(padding: EdgeInsets.only(top: 100), child: SizedBox(height: 40, width: 40, child: ShakleLoading())),
        ),
        Visibility(
          visible: zonesState.status == DataStatus.failure,
          child: Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Text(
              AppLocalizations.of(context)!.netFailure,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ),
      ],
    );
  }
}
