import 'package:flutter/material.dart';
import 'package:red_flags/models/activity.model.dart';
import 'package:red_flags/models/company.model.dart';
import 'package:red_flags/models/zone.model.dart';

class CreatePersonFormController {
  /// * Simple int flag.
  final ValueNotifier<int> state;

  String _firstname = "";
  String? get firstname => _firstname;

  String _lastname = "";
  String? get lastname => _lastname;

  DateTime? _birthDate;
  DateTime? get birthDate => _birthDate;

  Zone? _zone;
  Zone? get zone => _zone;
  void resetZone() => _zone = null;

  Activity? _activity;
  Activity? get activity => _activity;
  void resetActivity() => _activity = null;

  Company? _company;
  Company? get company => _company;
  void resetCompany() => _company = null;

  CreatePersonFormController(this.state);

  void updateValues({String? firstname, String? lastname, DateTime? birthDate, Zone? zone, Activity? activity, Company? company}) {
    _firstname = firstname ?? _firstname;
    _lastname = lastname ?? _lastname;
    _birthDate = birthDate ?? _birthDate;
    _zone = zone ?? _zone;
    _activity = activity ?? _activity;
    _company = company ?? _company;

    if (_firstname.length < 2 || _lastname.length < 2 || _birthDate == null) {
      state.value = 0;
      return;
    }

    if (_zone == null) {
      state.value = 1;
      return;
    }

    state.value = 2;
  }
}
