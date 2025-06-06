import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/core/results/failure.dart';
import 'package:red_flags/core/states/reactive_state.dart';
import 'package:red_flags/di/usecases_providers.dart';
import 'package:red_flags/domain/entities/person.entity.dart';
import 'package:red_flags/domain/usecases/search_persons.usecase.dart';

final searchPersonsStateProvider = StateNotifierProvider<SearchPersonsNotifier, PersonsState>((ref) {
  return SearchPersonsNotifier(ref.read(searchPersonsProvider));
});

class SearchPersonsNotifier extends StateNotifier<PersonsState> {
  final SearchPersons searchPersons;

  SearchPersonsNotifier(this.searchPersons) : super(PersonsState(status: ReactiveStateStatus.inactive, data: []));

  Future search({String? firstname, String? lastname, DateTime? birthDate, String? zoneID, String? companyID, String? activityID}) async {
    try {
      state = PersonsState(status: ReactiveStateStatus.loading, data: []);
      final result = await searchPersons.perform(
        SearchPersonsParams(
          firstname: firstname,
          lastname: lastname,
          birthDate: birthDate,
          zoneID: zoneID,
          activityID: companyID,
          companyID: activityID,
        ),
      );
      result.fold(
        (failureType) {
          state = PersonsState(status: ReactiveStateStatus.failure, data: [], failureType: failureType);
        },
        (persons) {
          state = PersonsState(status: ReactiveStateStatus.success, data: persons);
        },
      );
    } catch (err) {
      state = PersonsState(status: ReactiveStateStatus.failure, data: [], failureType: FailureType.unknown);
    }
  }

  /// TODO : Remove or complete.
  Future searchFromSingleInput(String inputValue) async {
    if (inputValue.isEmpty) {
      state = PersonsState(status: ReactiveStateStatus.inactive, data: []);
      return;
    }
    state = PersonsState(status: ReactiveStateStatus.loading, data: []);
  }

  void reset() => state = PersonsState(status: ReactiveStateStatus.inactive, data: []);
}

class PersonsState extends ReactiveState<List<Person>> {
  PersonsState({required super.status, required super.data, super.failureType});
}
