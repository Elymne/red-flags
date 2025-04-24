import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:red_flags/app/widgets/animation_background.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  /// The time delay before fetching data on input changes.
  final _searchDelayTimer = Duration(seconds: 1);
  Timer? _searchDelay;

  /// Inputs value references.
  String _firstname = "";
  String _lastname = "";
  String _zonename = "";
  String _jobname = "";

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.red,
        child: Stack(
          children: [
            /// r1 - Background animation.
            AnimationBackground(),

            /// r2 - Page title.
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppLocalizations.of(context)!.homeTitle,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),

            /// r3 - Inputs and button.
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Firstname Input.
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    child: TextField(
                      onChanged: (value) {
                        _firstname = value;
                        _onInputChange();
                      },
                      style: Theme.of(context).textTheme.labelMedium,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.firstNameInput,
                      ),
                    ),
                  ),
                  // Lastname Input.
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    child: TextField(
                      onChanged: (value) {
                        _lastname = value;
                        _onInputChange();
                      },
                      style: Theme.of(context).textTheme.labelMedium,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.lastNameInput,
                      ),
                    ),
                  ),
                  // Zone/City Input.
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    child: TextField(
                      onChanged: (value) {
                        _zonename = value;
                        _onInputChange();
                      },
                      style: Theme.of(context).textTheme.labelMedium,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.zoneInput,
                      ),
                    ),
                  ),
                  // Job name Input.
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    child: TextField(
                      onChanged: (value) {
                        _jobname = value;
                        _onInputChange();
                      },
                      style: Theme.of(context).textTheme.labelMedium,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.jobInput,
                      ),
                    ),
                  ),
                  // Validation Button with result number.
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          print("Clicked");
                        },
                        child: Text("SALUT"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
