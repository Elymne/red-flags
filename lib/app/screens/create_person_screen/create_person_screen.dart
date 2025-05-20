import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/app/widgets/page_change_related/slide_widget.dart';
import 'package:red_flags/app/widgets/shakles/shakle_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreatePersonScreen extends ConsumerStatefulWidget {
  const CreatePersonScreen({super.key});

  @override
  ConsumerState<CreatePersonScreen> createState() => _State();
}

class _State extends ConsumerState<CreatePersonScreen> {
  /// * Values for each textfield.
  String _firstname = "";
  String _lastname = "";

  /// *
  String _zoneName = "";

  String _activityName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          /// *
          children: [
            /// * Zone/City Input.
            // SlideWidget(
            //   duration: Duration(milliseconds: 1000),
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            //     child: ShakleInput(
            //       AppLocalizations.of(context)!.zonenameInput,
            //       autocompleteValues: state.zones.map((zone) => zone.name).toList(),
            //       onChanged: (value) {
            //         _zonename = value;
            //         _onTextfieldChange();
            //       },
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
