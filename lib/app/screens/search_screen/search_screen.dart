import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:red_flags/app/screens/search_screen/search_screen_state.dart';
import 'package:red_flags/app/widgets/fantom_widget.dart';
import 'package:red_flags/app/widgets/shakle_input.dart';
import 'package:red_flags/app/widgets/shakle_outlined_button.dart';
import 'package:red_flags/app/widgets/title_container.dart';
import 'package:red_flags/providers/persons/add_person.provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _State();
}

class _State extends ConsumerState<SearchScreen> with TickerProviderStateMixin {
  Timer? _searchDelay; // * The time delay before fetching persons on any textfield changes.

  // * Values for each textfield.
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

          /// * Firstname Input.
          SizedBox(height: 40),
          FantomWidget(
            duration: Duration(milliseconds: 400),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: ShakleInput(
                AppLocalizations.of(context)!.firstnameInput,
                animColor: Theme.of(context).colorScheme.primary,
                onChanged: (value) {
                  _firstname = value;
                  _onTextfieldChange();
                },
              ),
            ),
          ),

          /// * Lastname Input.
          FantomWidget(
            duration: Duration(milliseconds: 800),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: ShakleInput(
                AppLocalizations.of(context)!.lastnameInput,
                animColor: Theme.of(context).colorScheme.primary,
                onChanged: (value) {
                  _lastname = value;
                  _onTextfieldChange();
                },
              ),
            ),
          ),

          /// * Job name Input.
          FantomWidget(
            duration: Duration(milliseconds: 1200),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: ShakleInput(
                AppLocalizations.of(context)!.jobnameInput,
                animColor: Theme.of(context).colorScheme.primary,
                onChanged: (value) {
                  _jobname = value;
                  _onTextfieldChange();
                },
              ),
            ),
          ),

          /// * Zone/City Input.
          FantomWidget(
            duration: Duration(milliseconds: 1600),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: ShakleInput(
                AppLocalizations.of(context)!.zonenameInput,
                animColor: Theme.of(context).colorScheme.primary,
                autocompleteValues: state.zones.map((zone) => zone.name).toList(),
                onChanged: (value) {
                  _zonename = value;
                  _onTextfieldChange();
                },
              ),
            ),
          ),

          /// * Full spacer.
          Expanded(child: SizedBox()),

          /// * Disabled button because no value found yet.
          Visibility(
            visible: state.persons.isEmpty && (_firstname.isEmpty || _lastname.isEmpty || _jobname.isEmpty || _zonename.isEmpty),
            child: Align(
              alignment: Alignment.center,
              child: ShakleOutlinedButton(
                AppLocalizations.of(context)!.searchScreenLookButton,
                animColor: Theme.of(context).colorScheme.primary,
                isActive: false,
                onPressed: () {},
              ),
            ),
          ),

          /// * Create button because no value found at all.
          Visibility(
            visible: state.persons.isEmpty && _firstname.isEmpty && _lastname.isEmpty && _jobname.isEmpty && _zonename.isEmpty,
            child: Align(
              alignment: Alignment.center,
              child: ShakleOutlinedButton(
                AppLocalizations.of(context)!.searchScreenCreateButton,
                animColor: Theme.of(context).colorScheme.primary,
                isActive: true,
                onPressed: () async {
                  final params = AddPersonProviderParams(
                    firstname: _firstname,
                    lastname: _lastname,
                    zonename: _zonename,
                    jobname: _jobname,
                  );
                  await ref.read(addPersonProvider(params).future);
                },
              ),
            ),
          ),

          /// * Access button because values found.
          Visibility(
            visible: state.persons.isNotEmpty,
            child: Align(
              alignment: Alignment.center,
              child: ShakleOutlinedButton(
                "${AppLocalizations.of(context)!.searchScreenLookButton} (${state.persons.length})",
                animColor: Theme.of(context).colorScheme.primary,
                isActive: true,
                onPressed: () {
                  /// TODO : Access to ListView with the person create. Create the view.
                  if (kDebugMode) print("Clicked");
                },
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
