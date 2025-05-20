import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:red_flags/app/router/router.notifier.dart';
import 'package:red_flags/app/screens/person_list_view_screen/person_list_view_screen.dart';
import 'package:red_flags/app/screens/search_screen/search_screen_state.dart';
import 'package:red_flags/app/widgets/page_change_related/slide_widget.dart';
import 'package:red_flags/app/widgets/shakles/shakle_input.dart';
import 'package:red_flags/app/widgets/shakles/shakle_outlined_button.dart';
import 'package:red_flags/app/widgets/layouts/title_container.dart';
import 'package:red_flags/core/themes/style_constant.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _State();
}

class _State extends ConsumerState<SearchScreen> with TickerProviderStateMixin {
  /// * The time delay before fetching persons on any textfield changes.
  Timer? _searchDelay;

  /// * Values for each textfield.
  String _firstname = "";
  String _lastname = "";
  String _birthDate = "";
  String _zoneName = "";
  String _activityName = "";
  String _companyName = "";

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchScreenState);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(screenGlobalMargin),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// * Header container with page name.
            TitleContainer(
              title: AppLocalizations.of(context)!.searchScreenTitle,
              subtitle: AppLocalizations.of(context)!.searchScreenSubTitle,
            ),

            /// * Full spacer with background animation.
            Expanded(child: SizedBox()),

            /// * Lastname Input.
            SlideWidget(
              duration: Duration(milliseconds: 200),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: ShakleInput(
                  AppLocalizations.of(context)!.lastnameInput,
                  onChanged: (value) {
                    _lastname = value;
                    _onTextfieldChange();
                  },
                ),
              ),
            ),

            /// * Firstname Input.
            SlideWidget(
              duration: Duration(milliseconds: 400),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: ShakleInput(
                  AppLocalizations.of(context)!.firstnameInput,
                  onChanged: (value) {
                    _firstname = value;
                    _onTextfieldChange();
                  },
                ),
              ),
            ),

            /// * BirthDate Input.
            SlideWidget(
              duration: Duration(milliseconds: 200),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: ShakleInput(
                  AppLocalizations.of(context)!.birthDateInput,
                  autocompleteValues: state.zones.map((zone) => zone.name).toList(),
                  onChanged: (value) {
                    _birthDate = value;
                    _onTextfieldChange();
                  },
                ),
              ),
            ),

            /// * Zone name Input.
            SlideWidget(
              duration: Duration(milliseconds: 400),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: ShakleInput(
                  AppLocalizations.of(context)!.zoneNameInput,
                  onChanged: (value) {
                    _zoneName = value;
                    _onTextfieldChange();
                  },
                ),
              ),
            ),

            /// * Activity name Input.
            SlideWidget(
              duration: Duration(milliseconds: 400),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: ShakleInput(
                  AppLocalizations.of(context)!.activityNameInput,
                  onChanged: (value) {
                    _activityName = value;
                    _onTextfieldChange();
                  },
                ),
              ),
            ),

            /// * Company name Input.
            SlideWidget(
              duration: Duration(milliseconds: 600),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: ShakleInput(
                  AppLocalizations.of(context)!.activityNameInput,
                  autocompleteValues: state.zones.map((zone) => zone.name).toList(),
                  onChanged: (value) {
                    _companyName = value;
                    _onTextfieldChange();
                  },
                ),
              ),
            ),

            /// * Full spacer with background animation.
            Expanded(child: SizedBox()),

            /// * Disabled button because no value found yet.
            SlideWidget(
              duration: Duration(milliseconds: 400),
              child: Visibility(
                visible: state.persons.isEmpty,
                child: Align(
                  alignment: Alignment.center,
                  child: ShakleOutlinedButton(AppLocalizations.of(context)!.searchButton, isActive: false, onPressed: () {}),
                ),
              ),
            ),

            /// * Access button because values found.
            SlideWidget(
              duration: Duration(milliseconds: 400),
              child: Visibility(
                visible: state.persons.isNotEmpty,
                child: Align(
                  alignment: Alignment.center,
                  child: ShakleOutlinedButton(
                    "${AppLocalizations.of(context)!.searchButton} (${state.persons.length})",
                    isActive: true,
                    onPressed: () {
                      /// * Goto list view person widget.
                      ref.read(routerNotifierprovider.notifier).changeScreen(() {
                        /// * Navigate.
                        final navigator = Navigator.of(context);
                        navigator.push(MaterialPageRoute(builder: (context) => PersonListViewScreenScreen(persons: state.persons)));
                      });
                    },
                  ),
                ),
              ),
            ),

            /// * Bottom margin.
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// Called everytime value textfield from this widget is changed.
  /// This function fetch persons given textfield values.
  /// Allow me to know how many person can be find given the textfield values.
  void _onTextfieldChange() {
    _searchDelay?.cancel();
    _searchDelay = Timer(Duration(milliseconds: 200), () async {
      await ref
          .read(searchScreenState.notifier)
          .searchFromInput(
            firstname: _firstname,
            lastname: _lastname,
            birthDate: _birthDate,
            zoneName: _zoneName,
            activityName: _activityName,
            companyName: _companyName,
          );
    });
  }
}
