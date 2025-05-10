import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:red_flags/app/router/router.notifier.dart';
import 'package:red_flags/app/screens/search_screen/search_screen_state.dart';
import 'package:red_flags/app/widgets/page_change_related/slide_widget.dart';
import 'package:red_flags/app/widgets/shakles/shakle_input.dart';
import 'package:red_flags/app/widgets/shakles/shakle_outlined_button.dart';
import 'package:red_flags/app/widgets/layouts/title_container.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _State();
}

class _State extends ConsumerState<SearchScreen> with TickerProviderStateMixin {
  Timer? _searchDelay; // * The time delay before fetching persons on any textfield changes.

  /// * Values for each textfield.
  String _firstname = "";
  String _lastname = "";
  String _zonename = "";
  String _jobname = "";

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchScreenState);

    return Scaffold(
      body: Column(
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

          /// * Birthday Input.
          SlideWidget(
            duration: Duration(milliseconds: 600),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: ShakleInput(
                AppLocalizations.of(context)!.birthdayInput,
                autocompleteValues: state.zones.map((zone) => zone.name).toList(),
                onChanged: (value) {
                  _zonename = value;
                  _onTextfieldChange();
                },
              ),
            ),
          ),

          /// * Job name Input.
          SlideWidget(
            duration: Duration(milliseconds: 800),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: ShakleInput(
                AppLocalizations.of(context)!.jobnameInput,
                onChanged: (value) {
                  _jobname = value;
                  _onTextfieldChange();
                },
              ),
            ),
          ),

          /// * Zone/City Input.
          SlideWidget(
            duration: Duration(milliseconds: 1000),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: ShakleInput(
                AppLocalizations.of(context)!.zonenameInput,
                autocompleteValues: state.zones.map((zone) => zone.name).toList(),
                onChanged: (value) {
                  _zonename = value;
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
                      navigator.push(MaterialPageRoute(builder: (context) => const SearchScreen()));
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
    );
  }

  /// Called everytime value textfield from this widget is changed.
  /// This function fetch persons given textfield values.
  /// Allow me to know how many person can be find given the textfield values.
  void _onTextfieldChange() {
    _searchDelay?.cancel();
    _searchDelay = Timer(Duration(milliseconds: 200), () async {
      /// * Fetch the data.
      await ref.read(searchScreenState.notifier).searchFromInput(_firstname, _lastname, _zonename, _jobname);
    });
  }
}
