import 'package:red_flags/app/screens/create_person_screen/form_controller/create_person_form_controller.dart';
import 'package:red_flags/app/screens/create_person_screen/states/zones_state.dart';
import 'package:red_flags/app/widgets/listviews/card_single_line.dart';
import 'package:red_flags/app/widgets/listviews/slide_list_view.dart';
import 'package:red_flags/app/widgets/routing/slide_widget.dart';
import 'package:red_flags/app/widgets/shakles/shakle_loading.dart';
import 'package:red_flags/app/widgets/shakles/shakle_textfield.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:red_flags/core/states/widget_state.dart';

class FormZone extends ConsumerStatefulWidget {
  final CreatePersonFormController formCtrl;

  const FormZone({super.key, required this.formCtrl});

  @override
  ConsumerState<FormZone> createState() => _State();
}

class _State extends ConsumerState<FormZone> {
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
          visible: zonesState.status == WidgetStatus.success,
          child: Expanded(
            child: SlideListView(
              itemCount: zonesState.zones.length,
              itemBuilder: (_, index) {
                final zone = zonesState.zones[index];
                return CardSingleLine(
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
          visible: zonesState.status == WidgetStatus.loading,
          child: Padding(padding: EdgeInsets.only(top: 100), child: SizedBox(height: 40, width: 40, child: ShakleLoading())),
        ),
      ],
    );
  }
}
