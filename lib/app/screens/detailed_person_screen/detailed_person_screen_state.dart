import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/core/states/widget_state.dart';
import 'package:red_flags/models/detailed_person.model.dart';
import 'package:red_flags/providers/persons/get_person_by_id.dart';

final detailedPersonScreenState = StateNotifierProvider<DetailedPersonScreenNotifier, DetailedPersonScreenState>((ref) {
  return DetailedPersonScreenNotifier(ref);
});

class DetailedPersonScreenNotifier extends StateNotifier<DetailedPersonScreenState> {
  final Ref ref;

  DetailedPersonScreenNotifier(this.ref) : super(DetailedPersonScreenState(status: WidgetStatus.init, detailedPerson: null));

  Future<void> find(String id) async {
    try {
      /// * Loading status now, we're fetching some data.
      state = DetailedPersonScreenState(status: WidgetStatus.loading, detailedPerson: state.detailedPerson);

      /// * Fetch unique person.
      final getPersonParams = GetDetailedPersonProviderParams(id: id);
      final detailedPerson = await ref.read(getDetailedPersonProvider(getPersonParams).future);

      /// * And now update the state with new data.
      state = DetailedPersonScreenState(status: WidgetStatus.success, detailedPerson: detailedPerson);
    } catch (e, stack) {
      /// * An error occur.
      state = DetailedPersonScreenState(status: WidgetStatus.failure, detailedPerson: state.detailedPerson);
      log("$e $stack");
    }
  }
}

class DetailedPersonScreenState extends WidgetState {
  final DetailedPerson? detailedPerson;

  DetailedPersonScreenState({required super.status, required this.detailedPerson});
}
