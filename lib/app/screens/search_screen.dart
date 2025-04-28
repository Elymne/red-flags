import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:red_flags/app/widgets/fantom_widget.dart';
import 'package:red_flags/app/widgets/shakle_input.dart';
import 'package:red_flags/app/widgets/shakle_outlined_button.dart';
import 'package:red_flags/app/widgets/title_container.dart';
import 'package:red_flags/models/person.model.dart';
import 'package:red_flags/providers/persons/search_persons.provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _State();
}

class _State extends ConsumerState<SearchScreen> with TickerProviderStateMixin {
  late final PageController _pageController = PageController(initialPage: 0);

  /// The time delay before fetching data on input changes.
  Timer? _searchDelay;

  /// Inputs value references.
  String _firstname = "";
  String _lastname = "";
  String _zonename = "";
  String _jobname = "";

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
          FantomWidget(
            duration: Duration(milliseconds: 400),
            child: Padding(
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
          ),

          //Lastname Input.
          FantomWidget(
            duration: Duration(milliseconds: 800),
            child: Padding(
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
          ),
          // Zone/City Input.
          FantomWidget(
            duration: Duration(milliseconds: 1200),
            child: Padding(
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
          ),
          // Job name Input.
          FantomWidget(
            duration: Duration(milliseconds: 1600),
            child: Padding(
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
          ),
          // Validation Button with result number.
          FantomWidget(
            duration: Duration(milliseconds: 2000),
            child: SizedBox(
              height: 100,
              child: PageView(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: ShakleOutlinedButton(
                      AppLocalizations.of(context)!.searchButton,
                      animColor: Theme.of(context).colorScheme.primary,
                      isActive: false,
                      onPressed: () {
                        if (kDebugMode) print("Clicked");
                      },
                    ),
                  ),

                  Align(
                    alignment: Alignment.center,
                    child: ShakleOutlinedButton(
                      "${AppLocalizations.of(context)!.searchButton} (${persons.length})",
                      animColor: Theme.of(context).colorScheme.primary,
                      isActive: true,
                      onPressed: () {
                        if (kDebugMode) print("Clicked");
                      },
                    ),
                  ),

                  Align(
                    alignment: Alignment.center,
                    child: ShakleOutlinedButton(
                      AppLocalizations.of(context)!.createButton,
                      animColor: Theme.of(context).colorScheme.primary,
                      isActive: true,
                      onPressed: () {
                        if (kDebugMode) print("Clicked");
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Everytime an input is updated, we want to delay the time before fetching data to prevent big load on device and server.
  /// When this delay is passed, we start fetching data.
  void _onInputChange() {
    _searchDelay?.cancel();

    _searchDelay = Timer(Duration(milliseconds: 1000), () async {
      // Fetch the data.
      await ref
          .read(searchPersonsProvider.notifier)
          .search(firstname: _firstname, lastname: _lastname, zoneName: _zonename, jobname: _jobname);
      // Get persons from search ahead.
      final persons = ref.read(searchPersonsProvider).value;
      // Switch to ListView Screen Button.
      if (persons.isNotEmpty) {
        _pageController.animateToPage(1, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        return;
      }
      // Switch to CreateNew Screen Button.
      if (_firstname.isNotEmpty &&
          _lastname.isNotEmpty &&
          _zonename.isNotEmpty &&
          _jobname.isNotEmpty &&
          persons.isNotEmpty &&
          persons.isEmpty) {
        _pageController.animateToPage(2, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        return;
      }
      // Switch to Disabled Button.
      _pageController.animateToPage(0, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
      return;
    });
  }
}
