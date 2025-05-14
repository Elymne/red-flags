import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/app/screens/detailed_person_screen/detailed_person_screen_state.dart';
import 'package:red_flags/app/widgets/shakles/shakle_loading.dart';
import 'package:red_flags/app/widgets/shakles/shakle_text.dart';
import 'package:red_flags/core/states/widget_state.dart';

class DetailedPersonScreen extends ConsumerStatefulWidget {
  final String id;

  const DetailedPersonScreen({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<DetailedPersonScreen> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    /// * Fetch details about the person.
    ref.read(detailedPersonScreenState.notifier).find(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    /// * Watching detailedPerson Provider state.
    final personProvider = ref.watch(detailedPersonScreenState);

    /// The base.
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            /// * Init state : None Display.
            visible: personProvider.status == WidgetStatus.init,
            child: SizedBox(),
          ),

          Visibility(
            /// * Loading state : Circular Loading…
            visible: personProvider.status == WidgetStatus.loading,
            child: Expanded(child: Center(child: ShakleLoading())),
          ),

          Visibility(
            /// * Failure state : Display error text + return button.
            visible: personProvider.status == WidgetStatus.failure,
            child: Expanded(
              child: Center(
                child: ShakleText(AppLocalizations.of(context)!.applicationFailure, style: Theme.of(context).textTheme.bodyLarge),
              ),
            ),
          ),

          Visibility(
            /// TODO : detailed person.
            visible: personProvider.status == WidgetStatus.success,
            child: SizedBox(),
          ),
        ],
      ),
    );
  }
}
