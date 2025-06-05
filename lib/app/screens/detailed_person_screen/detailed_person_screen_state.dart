import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/core/states/widget_state.dart';
import 'package:red_flags/domain/models/person.model.dart';

final detailedPersonScreenState = StateNotifierProvider<DetailedPersonScreenNotifier, DetailedPersonScreenState>((ref) {
  return DetailedPersonScreenNotifier(ref);
});

class DetailedPersonScreenNotifier extends StateNotifier<DetailedPersonScreenState> {
  final Ref ref;

  DetailedPersonScreenNotifier(this.ref) : super(DetailedPersonScreenState(status: WidgetStatus.init, person: null));

  Future<void> find(String id) async {
    // try {
    //   /// * Loading status now, we're fetching some data.
    //   state = DetailedPersonScreenState(status: WidgetStatus.loading, person: state.person);while

    //   /// * Fetch unique person.
    //   final getPersonParams = GetPersonByIdParams(id: id);
    //   final detailedPerson = await ref.read(getPersonByID(getPersonParams).future);

    //   /// * And now update the state with new data.
    //   state = DetailedPersonScreenState(status: WidgetStatus.success, person: detailedPerson);
    // } catch (e, stack) {
    //   /// * An error occur.
    //   state = DetailedPersonScreenState(status: WidgetStatus.failure, person: state.person);
    //   log("$e $stack");
    // }
  }
}

class DetailedPersonScreenState extends WidgetState {
  final Person? person;

  DetailedPersonScreenState({required super.status, required this.person});
}
