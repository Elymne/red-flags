import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:red_flags/app/widgets/fantom_widget.dart';
import 'package:red_flags/app/widgets/shakle_input.dart';
import 'package:red_flags/app/widgets/shakle_outlined_button.dart';
import 'package:red_flags/app/widgets/title_container.dart';
import 'package:red_flags/providers/cities/get_zones.provider.dart';
import 'package:red_flags/providers/persons/get_persons.provider.dart';
import 'package:red_flags/providers/provider_value.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _State();
}

class _State extends ConsumerState<SearchScreen> with TickerProviderStateMixin {
  Timer? _searchDelay; // * The time delay before fetching persons on any textfield changes.
  Timer? _zoneSearchDelay; // * The time delay for zone fetching on zone textfield changes.

  // * Values for each textfield.
  String _firstname = "";
  String _lastname = "";
  String _zonename = "";
  String _jobname = "";

  @override
  Widget build(BuildContext context) {
    final personsProviderValue = ref.watch(getPersonsProvider);
    final persons = personsProviderValue.data;

    final zonesProviderValue = ref.watch(getZonesProvider);
    final zones = zonesProviderValue.data;

    final screenState = _getGlobalState();

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
                autocompleteValues: zones.map((zone) => zone.name).toList(),
                onChanged: (value) {
                  _zonename = value;
                  _onTextfieldChange();
                  _onZonefieldChange();
                },
              ),
            ),
          ),

          /// * Full spacer.
          Expanded(child: SizedBox()),

          /// * Not found.
          Visibility(
            visible: screenState == -1 || screenState == 0 || screenState == 1 || screenState == 2,
            child: Align(
              alignment: Alignment.center,
              child: ShakleOutlinedButton(
                AppLocalizations.of(context)!.searchScreenLookButton,
                animColor: Theme.of(context).colorScheme.primary,
                isActive: false,
                onPressed: () {
                  /// TODO : Access to ListView with the person create.
                  if (kDebugMode) print("Clicked");
                },
              ),
            ),
          ),

          /// * Found.
          Visibility(
            visible: screenState == 3,
            child: Align(
              alignment: Alignment.center,
              child: ShakleOutlinedButton(
                "${AppLocalizations.of(context)!.searchScreenLookButton} (${persons.length})",
                animColor: Theme.of(context).colorScheme.primary,
                isActive: true,
                onPressed: () {
                  /// TODO : Access to ListView with the person create.
                  if (kDebugMode) print("Clicked");
                },
              ),
            ),
          ),

          /// * Not found and and you can create a new one.
          Visibility(
            visible: screenState == 4,
            child: Align(
              alignment: Alignment.center,
              child: ShakleOutlinedButton(
                AppLocalizations.of(context)!.searchScreenCreateButton,
                animColor: Theme.of(context).colorScheme.primary,
                isActive: true,
                onPressed: () {
                  /// TODO : create new person.
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
    _searchDelay = Timer(Duration(milliseconds: 500), () async {
      /// * Fetch the data.
      await ref
          .read(getPersonsProvider.notifier)
          .searchBy(firstName: _firstname, lastName: _lastname, zoneName: _zonename, jobName: _jobname);
    });
  }

  /// Called everytime value textfield of zone is changed.
  /// This function fetch zones for my autocomplete zone textfield.
  void _onZonefieldChange() {
    _zoneSearchDelay?.cancel();
    _zoneSearchDelay = Timer(Duration(milliseconds: 500), () async {
      /// * Fetch the data.
      await ref.read(getZonesProvider.notifier).searchBy(_zonename);
    });
  }

  /// Called on each widget build or re-build.
  /// Allow me to know depending of int value returned, which element I should display or not.
  int _getGlobalState() {
    final providerValue = ref.read(getPersonsProvider);

    /// * An error occured.
    if (providerValue.state == ProviderState.exception || providerValue.state == ProviderState.failure) {
      return -1;
    }

    /// * Page is loading something.
    if (providerValue.state == ProviderState.loading) {
      return 1;
    }

    /// * Data has been found from textfield value.
    if (providerValue.data.isNotEmpty) {
      return 4;
    }

    /// * No data has been found from textfields values
    if (_firstname.isNotEmpty && _lastname.isNotEmpty && _zonename.isNotEmpty && _jobname.isNotEmpty && providerValue.data.isEmpty) {
      return 3;
    }

    /// * Not all textfield are completed but no found found.
    if (_firstname.isNotEmpty || _lastname.isNotEmpty || _zonename.isNotEmpty || _jobname.isNotEmpty) {
      return 2;
    }

    /// * Init state.
    return 0;
  }
}
