import 'package:flutter/material.dart';
import 'package:red_flags/models/activity.model.dart';
import 'package:red_flags/models/company.model.dart';
import 'package:red_flags/models/zone.model.dart';

class CreatePersonFormController {
  final ValueNotifier<int> state;

  final List<String> _errors = [];
  List<String> get errors => _errors;

  String _firstname = "";
  String get firstname => _firstname;

  String _lastname = "";
  String get lastname => _lastname;

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

    _checkErrors();

    if (_firstname.length < 2 && _lastname.length < 2 && _birthDate == null) {
      state.value = 0;
      return;
    }

    if (_zone == null) {
      state.value = 1;
      return;
    }

    state.value = 2;
  }

  void _checkErrors() {
    if (_firstname.isNotEmpty && _firstname.length < 2) _errors.add("Firstname should contains 2 or more characters!");
    if (_lastname.isNotEmpty && _lastname.length < 2) _errors.add("Lastname should contains 2 or more characters!");
  }
}
