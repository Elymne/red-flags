import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    // final personProvider = ref.watch(getDetailedPersonProvider);

    return SizedBox();

    // /// The base.
    // return Scaffold(
    //   body: Column(
    //     mainAxisSize: MainAxisSize.max,
    //     mainAxisAlignment: MainAxisAlignment.start,
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       /// Init state : None Display.
    //       Visibility(visible: personProvider.status == WidgetStatus.init, child: SizedBox()),

    //       /// Loading state : Circular Loading…
    //       Visibility(
    //         visible: personProvider.status == WidgetStatus.loading,
    //         child: Expanded(child: Center(child: ShakleLoading(animColor: Theme.of(context).colorScheme.primary))),
    //       ),

    //       /// Failure state : Display error text + return button.
    //       Visibility(
    //         visible: personProvider.status == WidgetStatus.failure,
    //         child: Expanded(
    //           child: Center(
    //             child: ShakleText(
    //               AppLocalizations.of(context)!.applicationFailure,
    //               style: Theme.of(context).textTheme.bodyLarge,
    //               animColor: Theme.of(context).colorScheme.primary,
    //             ),
    //           ),
    //         ),
    //       ),

    //       /// Failure state : Display error text + return button.
    //       Visibility(
    //         visible: personProvider.status == WidgetStatus.exception,
    //         child: Expanded(
    //           child: Center(
    //             child: ShakleText(
    //               AppLocalizations.of(context)!.netFailure,
    //               style: Theme.of(context).textTheme.bodyLarge,
    //               animColor: Theme.of(context).colorScheme.primary,
    //             ),
    //           ),
    //         ),
    //       ),

    //       /// TODO : detailed person.
    //       Visibility(visible: personProvider.status == WidgetStatus.success, child: SizedBox()),
    //     ],
    //   ),
    // );
  }
}
