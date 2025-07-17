import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/core/reactive/reactive_state.dart';
import 'package:red_flags/di/usecases_providers.dart';
import 'package:red_flags/domain/entities/activity.entity.dart';
import 'package:red_flags/domain/entities/company.entity.dart';
import 'package:red_flags/domain/entities/zone.entity.dart';
import 'package:red_flags/domain/usecases/check_new_person_form.usecase.dart';
import 'package:red_flags/infra/datasources/datasource_failure.enum.dart';

final personFormProvider = StateNotifierProvider<PersonFormStateNotifier, PersonFormState>((ref) {
  return PersonFormStateNotifier(ref.read(checkPersonFormProvider));
});

class PersonFormStateNotifier extends StateNotifier<PersonFormState> {
  final CheckNewPersonForm checkNewPersonForm;

  String? _firstname;
  String? get firstname => _firstname;
  void resetFirstname() => _firstname = null;

  String? _lastname;
  String? get lastname => _lastname;
  void resetLastname() => _lastname = null;

  DateTime? _birthDate;
  DateTime? get birthDate => _birthDate;
  void resetBirthDate() => _birthDate = null;

  Zone? _zone;
  Zone? get zone => _zone;
  void resetZone() => _zone = null;

  Activity? _activity;
  Activity? get activity => _activity;
  void resetActivity() => _activity = null;

  Company? _company;
  Company? get company => _company;
  void resetCompany() => _company = null;

  PersonFormStateNotifier(this.checkNewPersonForm)
    : super(PersonFormState(status: ReactiveStateStatus.inactive, data: [PersonFormInfo.imcomplete]));

  Future<void> onFormUpdate({
    String? firstname,
    String? lastname,
    DateTime? birthDate,
    Zone? zone,
    Activity? activity,
    Company? company,
  }) async {
    //* Check here
    if (firstname != null) _firstname = firstname;
    if (lastname != null) _lastname = lastname;
    if (birthDate != null) _birthDate = birthDate;
    if (zone != null) _zone = zone;
    if (company != null) _company = company;
    if (activity != null) _activity = activity;

    final result = await checkNewPersonForm.perform(
      CheckNewPersonFormParams(
        firstname: _firstname,
        lastname: _lastname,
        birthDate: _birthDate,
        activity: _activity,
        company: _company,
        zone: _zone,
      ),
    );

    result.fold(
      (failureType) {
        state = PersonFormState(status: ReactiveStateStatus.failure, data: [PersonFormInfo.error], failureType: failureType);
      },
      (infos) {
        state = PersonFormState(status: ReactiveStateStatus.success, data: infos);
      },
    );
  }

  void reset() {
    _firstname = "";
    _lastname = "";
    _birthDate = null;
    _zone = null;
    _activity = null;
    _company = null;
    state = PersonFormState(status: ReactiveStateStatus.inactive, data: []);
  }
}

class PersonFormState extends ReactiveState<List<PersonFormInfo>, DatasourceFailure> {
  PersonFormState({required super.status, required super.data, super.failureType});
}
