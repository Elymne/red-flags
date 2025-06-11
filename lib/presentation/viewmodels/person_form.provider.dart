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

  PersonFormStateNotifier(this.checkNewPersonForm) : super(PersonFormState(status: ReactiveStateStatus.inactive, data: []));

  Future<void> onFormUpdate({
    String? firstname,
    String? lastname,
    DateTime? birthDate,
    Zone? zone,
    Activity? activity,
    Company? company,
  }) async {
    //* Check here
  }

  void reset() {
    _firstname = null;
    _lastname = null;
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
