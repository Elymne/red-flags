import 'package:red_flags/core/reactive/reactive_state.dart';
import 'package:red_flags/presentation/viewmodels/companies.provider.dart';
import 'package:red_flags/presentation/viewmodels/person_form.provider.dart';
import 'package:red_flags/presentation/widgets/listviews/shakle_card.dart';
import 'package:red_flags/presentation/widgets/listviews/slide_list_view.dart';
import 'package:red_flags/presentation/widgets/routing/slide_widget.dart';
import 'package:red_flags/presentation/widgets/shakles/shakle_loading.dart';
import 'package:red_flags/presentation/widgets/shakles/shakle_textfield.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:red_flags/core/l10n/app_localizations.dart';

class FormWidgetCompany extends ConsumerStatefulWidget {
  const FormWidgetCompany({super.key});

  @override
  ConsumerState<FormWidgetCompany> createState() => _State();
}

class _State extends ConsumerState<FormWidgetCompany> {
  @override
  Widget build(BuildContext context) {
    final personFormNotifier = ref.read(personFormProvider.notifier);
    final companiesNotifier = ref.read(companiesProvider.notifier);
    final companiesState = ref.watch(companiesProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        SlideWidget(
          duration: Duration(milliseconds: 200),
          child: ShakleTextfield(
            AppLocalizations.of(context)!.companyName,
            onSubmitted: (value) {
              setState(() {
                personFormNotifier.resetCompany();
                companiesNotifier.search(value);
              });
            },
          ),
        ),
        Visibility(
          visible: companiesState.status == ReactiveStateStatus.success,
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Expanded(
              child: SlideListView(
                itemCount: companiesState.data.length,
                itemBuilder: (_, index) {
                  final company = companiesState.data[index];
                  return ShakleCard(
                    text: company.name,
                    subtext: company.address,
                    icon: Icons.location_on,
                    isActive: company.id == personFormNotifier.company?.id,
                    onTap: () {
                      setState(() => personFormNotifier.onFormUpdate(company: company));
                    },
                  );
                },
              ),
            ),
          ),
        ),
        Visibility(
          visible: companiesState.status == ReactiveStateStatus.loading,
          child: Padding(padding: EdgeInsets.only(top: 100), child: SizedBox(height: 40, width: 40, child: ShakleLoading())),
        ),
        Visibility(
          visible: companiesState.status == ReactiveStateStatus.failure,
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
