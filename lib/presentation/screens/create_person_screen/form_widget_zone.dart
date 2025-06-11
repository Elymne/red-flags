import 'package:red_flags/core/reactive/reactive_state.dart';
import 'package:red_flags/presentation/viewmodels/person_form.provider.dart';
import 'package:red_flags/presentation/viewmodels/zones.provider.dart';
import 'package:red_flags/presentation/widgets/listviews/shakle_card.dart';
import 'package:red_flags/presentation/widgets/listviews/slide_list_view.dart';
import 'package:red_flags/presentation/widgets/routing/slide_widget.dart';
import 'package:red_flags/presentation/widgets/shakles/shakle_loading.dart';
import 'package:red_flags/presentation/widgets/shakles/shakle_text_button.dart';
import 'package:red_flags/presentation/widgets/shakles/shakle_textfield.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:red_flags/core/l10n/app_localizations.dart';

class FormWidgetZone extends ConsumerStatefulWidget {
  const FormWidgetZone({super.key});

  @override
  ConsumerState<FormWidgetZone> createState() => _State();
}

class _State extends ConsumerState<FormWidgetZone> {
  @override
  Widget build(BuildContext context) {
    final personFormNotifier = ref.read(personFormProvider.notifier);
    final zoneNotifier = ref.read(zonesStateProvider.notifier);
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
                personFormNotifier.resetZone();
                zoneNotifier.search(value);
              });
            },
          ),
        ),
        Visibility(
          visible: zonesState.status == ReactiveStateStatus.success,
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Expanded(
              child: SlideListView(
                itemCount: zonesState.data.length,
                itemBuilder: (_, index) {
                  final zone = zonesState.data[index];
                  return ShakleCard(
                    text: zone.name,
                    icon: Icons.location_on,
                    isActive: zone.id == personFormNotifier.zone?.id,
                    onTap: () {
                      setState(() => personFormNotifier.onFormUpdate(zone: zone));
                    },
                  );
                },
              ),
            ),
          ),
        ),
        Visibility(
          visible: zonesState.status == ReactiveStateStatus.loading,
          child: Padding(padding: EdgeInsets.only(top: 100), child: SizedBox(height: 40, width: 40, child: ShakleLoading())),
        ),
        Visibility(
          visible: zonesState.status == ReactiveStateStatus.failure,
          child: Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Text(
              AppLocalizations.of(context)!.errorNetwork,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ),
        ShakleTextButton("Validate"),
      ],
    );
  }
}
