import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/core/reactive/reactive_state.dart';
import 'package:red_flags/di/usecases_providers.dart';
import 'package:red_flags/domain/usecases/check_new_person_form.usecase.dart';
import 'package:red_flags/infra/datasources/datasource_failure.enum.dart';

final personFormProvider = StateNotifierProvider<PersonFormStateNotifier, PersonFormState>((ref) {
  return PersonFormStateNotifier(ref.read(checkPersonFormProvider));
});

class PersonFormStateNotifier extends StateNotifier<PersonFormState> {
  final CheckNewPersonForm checkNewPersonForm;
  String? firstname;
  String? lastname;
  DateTime? birthDate;

  PersonFormStateNotifier(this.checkNewPersonForm) : super(PersonFormState(status: ReactiveStateStatus.inactive, data: []));

  Future<void> onInputChange({String? firstname, String? lastname}) async {}

  void reset() {
    firstname = null;
    lastname = null;
    birthDate = null;
    state = PersonFormState(status: ReactiveStateStatus.inactive, data: []);
  }
}

class PersonFormState extends ReactiveState<List<PersonFormInfo>, DatasourceFailure> {
  PersonFormState({required super.status, required super.data, super.failureType});
}
