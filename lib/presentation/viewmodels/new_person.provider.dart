import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/core/results/failure.dart';
import 'package:red_flags/di/usecases_providers.dart';
import 'package:red_flags/domain/usecases/add_new_person.usecase.dart';
import 'package:red_flags/core/states/reactive_state.dart';

final newPersonProvider = StateNotifierProvider<CreatePersonResultStateNotifier, NewPersonState>((ref) {
  return CreatePersonResultStateNotifier(ref.read(addNewPersonProvider));
});

class CreatePersonResultStateNotifier extends StateNotifier<NewPersonState> {
  final AddNewPerson addNewPerson;

  CreatePersonResultStateNotifier(this.addNewPerson) : super(NewPersonState(status: ReactiveStateStatus.inactive));

  Future<void> add({
    required String firstname,
    required String lastname,
    required DateTime birthDate,
    required String zoneID,
    required String companyID,
    required String activityID,
  }) async {
    try {
      state = NewPersonState(status: ReactiveStateStatus.loading);
      final result = await addNewPerson.perform(
        AddNewPersonParams(
          firstname: firstname,
          lastname: lastname,
          birthDate: birthDate,
          activityID: activityID,
          zoneID: zoneID,
          companyID: companyID,
        ),
      );

      result.fold(
        (failureType) {
          state = NewPersonState(status: ReactiveStateStatus.failure, failureType: failureType);
        },
        (nodata) {
          state = NewPersonState(status: ReactiveStateStatus.success);
        },
      );
    } catch (e) {
      state = NewPersonState(status: ReactiveStateStatus.failure, failureType: FailureType.unknown);
    }
  }

  void reset() => state = NewPersonState(status: ReactiveStateStatus.inactive);
}

class NewPersonState extends ReactiveState<Null> {
  NewPersonState({required super.status, super.data, super.failureType});
}
