import 'package:red_flags/domain/entities/activity.entity.dart';
import 'package:red_flags/domain/entities/company.entity.dart';
import 'package:red_flags/domain/entities/zone.entity.dart';

class Person {
  final String id;
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final Zone zone;
  final Activity activity;
  final Company company;
  final DateTime createdAt;
  final String? portrait;
  final String? description;

  Person({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.zone,
    required this.activity,
    required this.company,
    required this.createdAt,
    this.portrait,
    this.description,
  });
}
