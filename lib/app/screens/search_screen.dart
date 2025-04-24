import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:red_flags/app/widgets/title_container.dart';

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
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: TextField(
              onChanged: (value) {
                _firstname = value;
                _onInputChange();
              },
              style: Theme.of(context).textTheme.labelLarge,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.firstNameInput),
            ),
          ),
          // Lastname Input.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: TextField(
              onChanged: (value) {
                _lastname = value;
                _onInputChange();
              },
              style: Theme.of(context).textTheme.labelLarge,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.lastNameInput),
            ),
          ),
          // Zone/City Input.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: TextField(
              onChanged: (value) {
                _zonename = value;
                _onInputChange();
              },
              style: Theme.of(context).textTheme.labelLarge,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.zoneInput),
            ),
          ),
          // Job name Input.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: TextField(
              onChanged: (value) {
                _jobname = value;
                _onInputChange();
              },
              style: Theme.of(context).textTheme.labelLarge,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.jobInput),
            ),
          ),
          // Validation Button with result number.
          SizedBox(height: 20),

          // TODO : Change the button depending of what is returned by Search.
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              // TODO : Access to List persons page.
              ElevatedButton(
                onPressed: () {
                  if (kDebugMode) print("Clicked");
                },
                child: Text(AppLocalizations.of(context)!.searchButton),
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
    if (_searchDelay != null) {
      _searchDelay!.cancel();
    }
    _searchDelay = Timer(_searchDelayTimer, () {
      _searchDelay = null;
      if (kDebugMode) {
        print("$_firstname, $_lastname, $_zonename, $_jobname");
      }
    });
  }
}
