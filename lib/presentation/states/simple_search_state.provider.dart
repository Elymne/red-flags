import "dart:developer";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:red_flags/core/states/widget_state.dart";
import "package:red_flags/domain/entities/person.entity.dart";
import "package:red_flags/domain/usecases/persons/get_persons.provider.dart";

final simpleSearchStateProvider = StateNotifierProvider<SimpleSearchNotifier, SimpleSearchState>((ref) {
  return SimpleSearchNotifier(ref);
});

class SimpleSearchNotifier extends StateNotifier<SimpleSearchState> {
  final Ref ref;

  SimpleSearchNotifier(this.ref) : super(SimpleSearchState(status: WidgetStatus.init, persons: []));

  Future<void> searchFromInput(String inputValue) async {
    try {
      if (inputValue.isEmpty) {
        state = SimpleSearchState(status: WidgetStatus.init, persons: []);
        return;
      }

      state = SimpleSearchState(status: WidgetStatus.loading, persons: state.persons);

      // * Looking for ppl from the string value.
      String firstname = "";
      String lastname = "";
      String zoneName = "";
      final parts = inputValue.trim().split(RegExp(r"\s+"));

      switch (parts.length) {
        case 1:
          firstname = parts[0];
          break;
        case 2:
          firstname = parts[0];
          lastname = parts[1];
          break;
        case 3:
          firstname = parts[0];
          lastname = parts[1];
          zoneName = parts[2];
          break;
        default:
          firstname = parts[0];
          lastname = parts[1];
          zoneName = parts.sublist(2).join(" ");
      }

      final getPersonsParams = GetPersonsProviderParams(firstname: firstname, lastname: lastname);
      final persons = await ref.read(getPersonsProvider(getPersonsParams).future);

      state = SimpleSearchState(status: WidgetStatus.success, persons: persons);
    } catch (e, stack) {
      state = SimpleSearchState(status: WidgetStatus.failure, persons: state.persons);
      log("$e $stack");
    }
  }

  void reset() {
    state = SimpleSearchState(status: WidgetStatus.init, persons: []);
  }
}

class SimpleSearchState extends WidgetState {
  final List<Person> persons;
  SimpleSearchState({required super.status, required this.persons});
}
