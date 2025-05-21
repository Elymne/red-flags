import 'dart:async';
import 'package:red_flags/app/router/router.notifier.dart';
import 'package:red_flags/app/screens/create_person_screen/states/activities_state.provider.dart';
import 'package:red_flags/app/screens/create_person_screen/states/companies_state.provider.dart';
import 'package:red_flags/app/screens/create_person_screen/states/zones_state.dart';
import 'package:red_flags/app/widgets/page_change_related/slide_widget.dart';
import 'package:red_flags/app/widgets/layouts/title_container.dart';
import 'package:red_flags/app/widgets/shakles/shakle_date_picker.dart';
import 'package:red_flags/app/widgets/shakles/shakle_textfield.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:red_flags/app/widgets/shakles/shakle_outlined_button.dart';
import 'package:red_flags/core/themes/style_constant.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class CreatePersonScreen extends ConsumerStatefulWidget {
  const CreatePersonScreen({super.key});

  @override
  ConsumerState<CreatePersonScreen> createState() => _State();
}

class _State extends ConsumerState<CreatePersonScreen> {
  /// * The time delay before fetching persons on any textfield changes.
  Timer? _zoneSearchDelay;
  Timer? _activitySearchDelay;
  Timer? _companySearchDelay;

  /// * Values for each textfield.
  String _firstname = "";
  String _lastname = "";
  DateTime? _birthDate;
  String _zoneName = "";
  String _activityName = "";
  String _companyName = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(activitiesStateProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final zonesState = ref.watch(zonesStateProvider);
    final companiesState = ref.watch(companiesStateProvider);
    final activitiesState = ref.watch(activitiesStateProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(screenGlobalMargin),
          child: Column(
            children: [
              /// * Title
              TitleContainer(
                title: AppLocalizations.of(context)!.createScreenTitle,
                subtitle: AppLocalizations.of(context)!.createScreenSubTitle,
              ),

              /// * Spacer.
              Expanded(child: SizedBox()),

              /// * Textfield firstname
              SlideWidget(
                duration: Duration(milliseconds: 200),
                child: ShakleTextfield(
                  "${AppLocalizations.of(context)!.firstname}*",
                  onChanged: (value) {
                    _firstname = value;
                  },
                ),
              ),

              /// * Spacer.
              SizedBox(height: 20),

              /// * Textfield lastname
              SlideWidget(
                duration: Duration(milliseconds: 400),
                child: ShakleTextfield(
                  "${AppLocalizations.of(context)!.lastname}*",
                  onChanged: (value) {
                    _lastname = value;
                  },
                ),
              ),

              /// * Spacer.
              SizedBox(height: 20),

              /// * Textfield birthDate
              SlideWidget(
                duration: Duration(milliseconds: 600),
                child: ShakleDatepicker(
                  "${AppLocalizations.of(context)!.birthDate}*",
                  onChanged: (value) {
                    _birthDate = value;
                  },
                ),
              ),

              /// * Spacer.
              SizedBox(height: 20),

              /// * Textfield ZoneName
              SlideWidget(
                duration: Duration(milliseconds: 800),
                child: ShakleTextfield(
                  "${AppLocalizations.of(context)!.zoneName}*",
                  autocompleteValues: zonesState.zones.map((element) => element.name).toList(),
                  onChanged: (value) {
                    _zoneSearchDelay?.cancel();
                    _zoneSearchDelay = Timer(Duration(milliseconds: 300), () async {
                      await ref.read(zonesStateProvider.notifier).search(value);
                      _zoneName = value;
                    });
                  },
                ),
              ),

              /// * Spacer.
              SizedBox(height: 20),

              /// * Textfield CompanyName
              SlideWidget(
                duration: Duration(milliseconds: 1200),
                child: ShakleTextfield(
                  AppLocalizations.of(context)!.companyName,
                  autocompleteValues: companiesState.companies.map((element) => element.name).toList(),
                  onChanged: (value) {
                    _companySearchDelay?.cancel();
                    _companySearchDelay = Timer(Duration(milliseconds: 300), () async {
                      ref.read(companiesStateProvider.notifier).search(value);
                      _companyName = value;
                    });
                  },
                ),
              ),

              /// * Spacer.
              SizedBox(height: 20),

              /// * Textfield ActivityName
              SlideWidget(
                duration: Duration(milliseconds: 1000),
                child: ShakleTextfield(
                  AppLocalizations.of(context)!.activityName,
                  autocompleteValues: activitiesState.activities.map((element) => element.name).toList(),
                  onChanged: (value) {
                    _activitySearchDelay?.cancel();
                    _activitySearchDelay = Timer(Duration(milliseconds: 300), () async {
                      // ref.read(activitiesStateProvider.notifier).search(value);
                      _activityName = value;
                    });
                  },
                ),
              ),

              /// * Spacer
              Expanded(child: SizedBox()),

              /// * Button Disable
              SlideWidget(
                duration: Duration(milliseconds: 1400),
                child: Visibility(
                  visible: true,
                  child: Align(
                    alignment: Alignment.center,
                    child: ShakleOutlinedButton(AppLocalizations.of(context)!.createButton, isActive: false, onPressed: () {}),
                  ),
                ),
              ),

              /// * Button Create
              SlideWidget(
                duration: Duration(milliseconds: 1400),
                child: Visibility(
                  visible: false,
                  child: Align(
                    alignment: Alignment.center,
                    child: ShakleOutlinedButton(
                      AppLocalizations.of(context)!.createButton,
                      isActive: true,
                      onPressed: () {
                        /// * Goto list view person widget.
                        ref.read(routerNotifierprovider.notifier).changeScreen(() {});
                      },
                    ),
                  ),
                ),
              ),

              /// * Marge
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
