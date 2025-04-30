import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:red_flags/app/widgets/fantom_widget.dart';
import 'package:red_flags/app/widgets/shakle_input.dart';
import 'package:red_flags/app/widgets/shakle_outlined_button.dart';
import 'package:red_flags/app/widgets/shakle_text.dart';
import 'package:red_flags/app/widgets/title_container.dart';
import 'package:red_flags/providers/persons/search_persons.provider.dart';
import 'package:red_flags/providers/provider_value.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _State();
}

class _State extends ConsumerState<SearchScreen> with TickerProviderStateMixin {
  /// The time delay before fetching data on input changes.
  Timer? _searchDelay;

  /// Inputs value references.
  String _firstname = "";
  String _lastname = "";
  String _zonename = "";
  String _jobname = "";

  @override
  Widget build(BuildContext context) {
    final persons = ref.watch(searchPersonsProvider).value;
    final indexResult = _getIndexResult();

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header container with page name.
          TitleContainer(
            title: AppLocalizations.of(context)!.searchScreenTitle,
            subtitle: AppLocalizations.of(context)!.searchScreenSubTitle,
          ),

          /// Firstname Input.
          SizedBox(height: 40),
          FantomWidget(
            duration: Duration(milliseconds: 400),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: ShakleInput(
                AppLocalizations.of(context)!.firstnameInput,
                animColor: Theme.of(context).colorScheme.primary,
                autocompleteValues: ["HELLO", "WORLD", "HOLA!", "Mais qui est là?"],
                onChanged: (value) {
                  _firstname = value;
                  _onInputChange();
                },
              ),
            ),
          ),

          /// Lastname Input.
          FantomWidget(
            duration: Duration(milliseconds: 800),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: ShakleInput(
                AppLocalizations.of(context)!.lastnameInput,
                animColor: Theme.of(context).colorScheme.primary,
                autocompleteValues: [],
                onChanged: (value) {
                  _lastname = value;
                  _onInputChange();
                },
              ),
            ),
          ),

          /// Zone/City Input.
          FantomWidget(
            duration: Duration(milliseconds: 1200),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: ShakleInput(
                AppLocalizations.of(context)!.zonenameInput,
                animColor: Theme.of(context).colorScheme.primary,
                autocompleteValues: [],
                onChanged: (value) {
                  _zonename = value;
                  _onInputChange();
                },
              ),
            ),
          ),

          /// Job name Input.
          FantomWidget(
            duration: Duration(milliseconds: 1600),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: ShakleInput(
                AppLocalizations.of(context)!.jobnameInput,
                animColor: Theme.of(context).colorScheme.primary,
                autocompleteValues: ["HELLO", "WORLD", "HOLA!"],
                onChanged: (value) {
                  _jobname = value;
                  _onInputChange();
                },
              ),
            ),
          ),

          /// TODO : Message helper (error, advice, guidance).
          SizedBox(height: 20),

          /// Init Message.
          Visibility(
            visible: indexResult == 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: ShakleText(
                AppLocalizations.of(context)!.searchScreenInitMessage,
                speedAnimation: Duration(milliseconds: 10),
                force: 0.4,
                style: Theme.of(context).textTheme.bodyLarge,
                animColor: Theme.of(context).colorScheme.primary,
                hasIdleAnim: true,
              ),
            ),
          ),

          /// Not Found Message.
          Visibility(
            visible: indexResult == 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: ShakleText(
                AppLocalizations.of(context)!.searchScreenNotFoundMessage,
                speedAnimation: Duration(milliseconds: 10),
                force: 0.4,
                style: Theme.of(context).textTheme.bodyLarge,
                animColor: Theme.of(context).colorScheme.primary,
                hasIdleAnim: true,
              ),
            ),
          ),

          /// Found Message.
          Visibility(
            visible: indexResult == 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: ShakleText(
                AppLocalizations.of(context)!.searchScreenFoundMessage,
                speedAnimation: Duration(milliseconds: 10),
                force: 0.4,
                style: Theme.of(context).textTheme.bodyLarge,
                animColor: Theme.of(context).colorScheme.primary,
                hasIdleAnim: true,
              ),
            ),
          ),

          /// Create Message.
          Visibility(
            visible: indexResult == 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: ShakleText(
                AppLocalizations.of(context)!.searchScreenCreateMessage,
                speedAnimation: Duration(milliseconds: 10),
                force: 0.4,
                style: Theme.of(context).textTheme.bodyLarge,
                animColor: Theme.of(context).colorScheme.primary,
                hasIdleAnim: true,
              ),
            ),
          ),

          /// Error Message.
          Visibility(
            visible: indexResult == 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: ShakleText(
                AppLocalizations.of(context)!.searchScreenErrorMessage,
                speedAnimation: Duration(milliseconds: 10),
                force: 0.4,
                style: Theme.of(context).textTheme.bodyLarge,
                animColor: Theme.of(context).colorScheme.primary,
                hasIdleAnim: true,
              ),
            ),
          ),

          /// Full spacer.
          Expanded(child: SizedBox()),

          /// Not found.
          Visibility(
            visible: _getIndexResult() == 1,
            child: Align(
              alignment: Alignment.center,
              child: ShakleOutlinedButton(
                AppLocalizations.of(context)!.searchScreenDisabledButton,
                animColor: Theme.of(context).colorScheme.primary,
                isActive: false,
                onPressed: () {},
              ),
            ),
          ),

          /// Found.
          Visibility(
            visible: _getIndexResult() == 2,
            child: Align(
              alignment: Alignment.center,
              child: ShakleOutlinedButton(
                "${AppLocalizations.of(context)!.searchScreenLookButton} (${persons.length})",
                animColor: Theme.of(context).colorScheme.primary,
                isActive: true,
                onPressed: () {
                  if (kDebugMode) print("Clicked");
                },
              ),
            ),
          ),

          /// Not found and and you can create a new one.
          Visibility(
            visible: _getIndexResult() == 3,
            child: Align(
              alignment: Alignment.center,
              child: ShakleOutlinedButton(
                AppLocalizations.of(context)!.searchScreenCreateButton,
                animColor: Theme.of(context).colorScheme.primary,
                isActive: true,
                onPressed: () {
                  if (kDebugMode) print("Clicked");
                },
              ),
            ),
          ),

          SizedBox(height: 20),
        ],
      ),
    );
  }

  /// Everytime an input is updated, we want to delay the time before fetching data to prevent big load on device and server.
  /// When this delay is passed, we start fetching data.
  void _onInputChange() {
    _searchDelay?.cancel();

    _searchDelay = Timer(Duration(milliseconds: 1000), () async {
      /// Fetch the data.
      await ref
          .read(searchPersonsProvider.notifier)
          .search(firstname: _firstname, lastname: _lastname, zoneName: _zonename, jobname: _jobname);
    });
  }

  /// This function simply give us the correct button to display + correct message.
  int _getIndexResult() {
    /// Get persons from search ahead.
    final providerValue = ref.read(searchPersonsProvider);

    /// An error occured while fetching data.
    if (providerValue.state == ProviderState.failure) {
      return 4;
    }

    /// Switch to ListView Screen Button.
    if (providerValue.value.isNotEmpty) {
      return 2;
    }

    /// Switch to CreateNew Screen Button.
    if (_firstname.isNotEmpty && _lastname.isNotEmpty && _zonename.isNotEmpty && _jobname.isNotEmpty && providerValue.value.isEmpty) {
      return 3;
    }

    /// Switch to Disabled Button.
    if (_firstname.isNotEmpty || _lastname.isNotEmpty || _zonename.isNotEmpty || _jobname.isNotEmpty) {
      return 1;
    }

    /// Default stance.
    return 0;
  }
}
