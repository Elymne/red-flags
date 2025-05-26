import 'package:red_flags/app/screens/create_person_screen/form_controller/person_form_controller.dart';
import 'package:red_flags/app/screens/create_person_screen/states/companies_state.provider.dart';
import 'package:red_flags/app/widgets/listviews/shakle_card.dart';
import 'package:red_flags/app/widgets/listviews/slide_list_view.dart';
import 'package:red_flags/app/widgets/routing/slide_widget.dart';
import 'package:red_flags/app/widgets/shakles/shakle_loading.dart';
import 'package:red_flags/app/widgets/shakles/shakle_textfield.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:red_flags/core/states/widget_state.dart';

class FormCompany extends ConsumerStatefulWidget {
  final PersonFormController formCtrl;

  const FormCompany({super.key, required this.formCtrl});

  @override
  ConsumerState<FormCompany> createState() => _State();
}

class _State extends ConsumerState<FormCompany> {
  @override
  Widget build(BuildContext context) {
    final companiesState = ref.watch(companiesStateProvider);

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
                ref.read(companiesStateProvider.notifier).search(value);
              });
            },
          ),
        ),
        SizedBox(height: 20),
        Visibility(
          visible: companiesState.status == WidgetStatus.success,
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
          visible: companiesState.status == WidgetStatus.loading,
          child: Padding(padding: EdgeInsets.only(top: 100), child: SizedBox(height: 40, width: 40, child: ShakleLoading())),
        ),
        Visibility(
          visible: companiesState.status == WidgetStatus.failure,
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
