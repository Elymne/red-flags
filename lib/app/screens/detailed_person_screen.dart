import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/app/widgets/shakle_loading.dart';
import 'package:red_flags/app/widgets/shakle_text.dart';
import 'package:red_flags/providers/persons/get_detailed_person.provider.dart';
import 'package:red_flags/providers/provider_value.dart';

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

    /// Async fetch detailed person.
    // ref.read(getDetailedPersonProvider.notifier).fetchUnique(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    /// Watching detailedPerson Provider state.
    final personProvider = ref.watch(getDetailedPersonProvider);

    /// The base.
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Init state : None Display.
          Visibility(visible: personProvider.state == ProviderState.init, child: SizedBox()),

          /// Loading state : Circular Loading…
          Visibility(
            visible: personProvider.state == ProviderState.loading,
            child: Expanded(child: Center(child: ShakleLoading(animColor: Theme.of(context).colorScheme.primary))),
          ),

          /// Failure state : Display error text + return button.
          Visibility(
            visible: personProvider.state == ProviderState.failure,
            child: Expanded(
              child: Center(
                child: ShakleText(
                  AppLocalizations.of(context)!.personDetailedScreenFailure,
                  style: Theme.of(context).textTheme.bodyLarge,
                  animColor: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),

          /// Failure state : Display error text + return button.
          Visibility(
            visible: personProvider.state == ProviderState.exception,
            child: Expanded(
              child: Center(
                child: ShakleText(
                  AppLocalizations.of(context)!.personDetailedScreenException,
                  style: Theme.of(context).textTheme.bodyLarge,
                  animColor: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),

          /// TODO : detailed person.
          Visibility(visible: personProvider.state == ProviderState.success, child: SizedBox()),
        ],
      ),
    );
  }
}
