import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/models/activity.model.dart';
import 'package:red_flags/models/company.model.dart';
import 'package:red_flags/models/zone.model.dart';

/// Unused because it's probably useless.
final personFormProvider = StateNotifierProvider<PersonFormStateNotifier, PersonFormState>((ref) => PersonFormStateNotifier(ref));

class PersonFormStateNotifier extends StateNotifier<PersonFormState> {
  final Ref ref;

  PersonFormStateNotifier(this.ref) : super(PersonFormState.empty());

  void updateValues({
    int? currentPage,
    String? firstname,
    String? lastname,
    DateTime? birthDate,
    Zone? zone,
    Activity? activity,
    Company? company,
  }) {
    state = PersonFormState(
      currentPage: currentPage ?? state.currentPage,
      firstname: firstname ?? state.firstname,
      lastname: lastname ?? state.lastname,
      birthDate: birthDate ?? state.birthDate,
      zone: zone ?? state.zone,
      activity: activity ?? state.activity,
      company: company ?? state.company,
    );
  }

  void resetZone() => {
    state = PersonFormState(
      currentPage: state.currentPage,
      firstname: state.firstname,
      lastname: state.lastname,
      birthDate: state.birthDate,
      zone: null,
      activity: state.activity,
      company: state.company,
    ),
  };

  void resetActivity() => {
    state = PersonFormState(
      currentPage: state.currentPage,
      firstname: state.firstname,
      lastname: state.lastname,
      birthDate: state.birthDate,
      zone: state.zone,
      activity: null,
      company: state.company,
    ),
  };

  void resetCompany() => {
    state = PersonFormState(
      currentPage: state.currentPage,
      firstname: state.firstname,
      lastname: state.lastname,
      birthDate: state.birthDate,
      zone: state.zone,
      activity: state.activity,
      company: null,
    ),
  };

  void resetAll() => state = PersonFormState.empty();
}

class PersonFormState {
  final int currentPage;
  final String firstname;
  final String lastname;
  final DateTime? birthDate;
  final Zone? zone;
  final Activity? activity;
  final Company? company;

  PersonFormState({
    required this.currentPage,
    required this.firstname,
    required this.lastname,
    required this.birthDate,
    required this.zone,
    required this.activity,
    required this.company,
  });

  factory PersonFormState.empty() {
    return PersonFormState(currentPage: 0, firstname: '', lastname: '', birthDate: null, zone: null, activity: null, company: null);
  }
}
