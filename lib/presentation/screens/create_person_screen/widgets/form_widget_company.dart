import 'package:red_flags/presentation/screens/create_person_screen/person_form_state.dart';
import 'package:red_flags/presentation/viewmodels/companies.provider.dart';
import 'package:red_flags/presentation/widgets/listviews/shakle_card.dart';
import 'package:red_flags/presentation/widgets/listviews/slide_list_view.dart';
import 'package:red_flags/presentation/widgets/routing/slide_widget.dart';
import 'package:red_flags/presentation/widgets/shakles/shakle_loading.dart';
import 'package:red_flags/presentation/widgets/shakles/shakle_textfield.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:red_flags/core/l10n/app_localizations.dart';
import 'package:red_flags/core/states/reactive_state.dart';

class FormWidgetCompany extends ConsumerStatefulWidget {
  final PersonFormState formCtrl;

  const FormWidgetCompany({super.key, required this.formCtrl});

  @override
  ConsumerState<FormWidgetCompany> createState() => _State();
}

class _State extends ConsumerState<FormWidgetCompany> {
  @override
  Widget build(BuildContext context) {
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
                widget.formCtrl.resetCompany();
                ref.read(companiesProvider.notifier).search(value);
              });
            },
          ),
        ),
        SizedBox(height: 20),
        Visibility(
          visible: companiesState.status == DataStatus.success,
          child: Expanded(
            child: SlideListView(
              itemCount: companiesState.companies.length,
              itemBuilder: (_, index) {
                final company = companiesState.companies[index];
                return ShakleCard(
                  text: company.name,
                  subtext: company.address,
                  icon: Icons.location_on,
                  isActive: company.id == widget.formCtrl.company?.id,
                  onTap: () {
                    setState(() => widget.formCtrl.updateValues(company: company));
                  },
                );
              },
            ),
          ),
        ),
        Visibility(
          visible: companiesState.status == DataStatus.loading,
          child: Padding(padding: EdgeInsets.only(top: 100), child: SizedBox(height: 40, width: 40, child: ShakleLoading())),
        ),
        Visibility(
          visible: companiesState.status == DataStatus.failure,
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
