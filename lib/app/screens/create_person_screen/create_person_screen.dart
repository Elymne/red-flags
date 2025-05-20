import 'dart:async';
import 'package:red_flags/app/router/router.notifier.dart';
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
  Timer? _searchDelay;

  /// * Values for each textfield.
  String _firstname = "";
  String _lastname = "";
  String _birthDate = "";
  String _zoneID = "";
  String _activityID = "";
  String _companyID = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
                  _onTextfieldChange();
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
                  _onTextfieldChange();
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
                  _zoneID = value;
                  _onTextfieldChange();
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
                onChanged: (value) {
                  _zoneID = value;
                  _onTextfieldChange();
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
                onChanged: (value) {
                  _activityID = value;
                  _onTextfieldChange();
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
                onChanged: (value) {
                  _activityID = value;
                  _onTextfieldChange();
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
    );
  }

  void _onTextfieldChange() {
    _searchDelay?.cancel();
    _searchDelay = Timer(Duration(milliseconds: 200), () async {});
  }
}
