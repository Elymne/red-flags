import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:red_flags/app/widgets/neon_elevated_button.dart';
import 'package:red_flags/app/widgets/shakle_input.dart';
import 'package:red_flags/app/widgets/shakle_outlined_button.dart';
import 'package:red_flags/app/widgets/title_container.dart';
import 'package:red_flags/providers/persons/search_persons.provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _State();
}

class _State extends ConsumerState<SearchScreen> {
  /// The time delay before fetching data on input changes.
  final _searchDelayTimer = Duration(seconds: 1);
  Timer? _searchDelay;

  // Page controller for button
  late final PageController pageController;

  /// Inputs value references.
  String _firstname = "";
  String _lastname = "";
  String _zonename = "";
  String _jobname = "";

  @override
  void initState() {
    super.initState();
    // Set the page controller for action button.
    pageController = PageController(initialPage: 0, viewportFraction: 1);
  }

  @override
  Widget build(BuildContext context) {
    final persons = ref.watch(searchPersonsProvider).value;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header container with page name.
          TitleContainer(
            title: AppLocalizations.of(context)!.searchScreenTitle,
            subtitle: AppLocalizations.of(context)!.searchScreenSubTitle,
          ),

          // Firstname Input.
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: ShakleInput(
              AppLocalizations.of(context)!.firstNameInput,
              animColor: Theme.of(context).colorScheme.primary,
              onChanged: (value) {
                _firstname = value;
                _onInputChange();
              },
            ),
          ),
          //Lastname Input.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: ShakleInput(
              AppLocalizations.of(context)!.lastNameInput,
              animColor: Theme.of(context).colorScheme.primary,
              onChanged: (value) {
                _lastname = value;
                _onInputChange();
              },
            ),
          ),
          // Zone/City Input.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: ShakleInput(
              AppLocalizations.of(context)!.zoneInput,
              animColor: Theme.of(context).colorScheme.primary,
              onChanged: (value) {
                _zonename = value;
                _onInputChange();
              },
            ),
          ),
          // Job name Input.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: ShakleInput(
              AppLocalizations.of(context)!.jobInput,
              animColor: Theme.of(context).colorScheme.primary,
              onChanged: (value) {
                _jobname = value;
                _onInputChange();
              },
            ),
          ),
          // Validation Button with result number.
          SizedBox(height: 20),

          // TODO : Change the button depending of what is returned by Search.
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              // TODO : Blocked button
              // ElevatedButton(
              //   onPressed: () {
              //     if (kDebugMode) print("Clicked");
              //   },
              //   child: Text("${AppLocalizations.of(context)!.searchButton} (${persons.length})"),
              // ),

              // TODO : Access to List persons page.
              ShakleOutlinedButton(
                "${AppLocalizations.of(context)!.searchButton} (${persons.length})",
                animColor: Theme.of(context).colorScheme.primary,
                isActive: true,
                onPressed: () {
                  if (kDebugMode) print("Clicked");
                },
              ),

              // TODO : Create a new entry and access to unique person created.
              // ElevatedButton(
              //   onPressed: () {
              //     if (kDebugMode) print("Clicked");
              //   },
              //   child: Text(AppLocalizations.of(context)!.searchButton),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  /// Everytime an input is updated, we want to delay the time before fetching data to prevent big load on device and server.
  /// When this delay is passed, we start fetching data.
  void _onInputChange() {
    _searchDelay?.cancel();

    _searchDelay = Timer(_searchDelayTimer, () {
      print("SEARCHING NOW !");
      ref.read(searchPersonsProvider.notifier).search(firstname: _firstname, lastname: _lastname, zoneName: _zonename, jobname: _jobname);
    });
  }
}
