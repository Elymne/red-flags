import 'package:red_flags/core/reactive/reactive_state.dart';
import 'package:red_flags/presentation/viewmodels/current_page.provider.dart';
import 'package:red_flags/presentation/viewmodels/person_form.provider.dart';
import 'package:red_flags/presentation/viewmodels/zones.provider.dart';
import 'package:red_flags/presentation/widgets/forms/form_textfield.dart';
import 'package:red_flags/presentation/widgets/listviews/card_single.dart';
import 'package:red_flags/presentation/widgets/listviews/slide_list_view.dart';
import 'package:red_flags/presentation/widgets/routing/slide_widget.dart';
import 'package:red_flags/presentation/widgets/routing/title_pop_text.dart';
import 'package:red_flags/presentation/widgets/shakles/shakle_loading.dart';
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
    final currentPageNotifier = ref.read(currentPageProvider.notifier);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitlePopText(
          "Sélectionner une région :",
          animTic: Duration(milliseconds: 40),
          style: Theme.of(context).textTheme.headlineMedium,
          hasIdleAnim: true,
          color: Theme.of(context).colorScheme.primary,
        ),

        SizedBox(height: 20),

        SlideWidget(
          duration: Duration(milliseconds: 600),
          child: FormTextfield(
            icon: Icons.search,
            label: AppLocalizations.of(context)!.searchButton,
            value: "",
            onSubmitted: (value) {
              zoneNotifier.search(value);
            },
          ),
        ),

        Visibility(
          visible: zonesState.status == ReactiveStateStatus.success && zonesState.data.isNotEmpty,
          child: Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: SlideListView(
                itemCount: zonesState.data.length,
                itemBuilder: (_, index) {
                  final zone = zonesState.data[index];
                  return CardSingle(
                    text: zone.name,
                    icon: Icons.location_on,
                    onTap: () {
                      personFormNotifier.onFormUpdate(zone: zone);
                      currentPageNotifier.setCurrentPage(0);
                      zoneNotifier.reset();
                    },
                  );
                },
              ),
            ),
          ),
        ),

        Visibility(
          visible: zonesState.status == ReactiveStateStatus.success && zonesState.data.isEmpty,
          child: Expanded(child: Center(child: Padding(padding: const EdgeInsets.only(top: 20), child: Text("Empty list")))),
        ),

        Visibility(
          visible: zonesState.status == ReactiveStateStatus.loading,
          child: Expanded(child: Center(child: SizedBox(height: 40, width: 40, child: ShakleLoading()))),
        ),

        Visibility(
          visible: zonesState.status == ReactiveStateStatus.failure,
          child: Expanded(
            child: Center(
              child: Text(
                AppLocalizations.of(context)!.errorNetwork,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ),
        ),

        Visibility(visible: zonesState.status == ReactiveStateStatus.inactive, child: Expanded(child: SizedBox())),

        Align(
          alignment: Alignment(0, -1),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SlideWidget(
              duration: Duration(milliseconds: 200),
              child: OutlinedButton(
                onPressed: () {
                  currentPageNotifier.setCurrentPage(0);
                  zoneNotifier.reset();
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
