import 'package:red_flags/infra/models/activity.model.dart';
import 'package:red_flags/infra/models/company.model.dart';
import 'package:red_flags/infra/models/zone.model.dart';

class PersonModel {
  final String id;
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final ZoneModel zone;
  final ActivityModel activity;
  final CompanyModel company;
  final DateTime createdAt;
  final String? portrait;
  final String? description;

  PersonModel({
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

  factory PersonModel.fromJson(Map<String, dynamic> json) {
    return PersonModel(
      id: json["ID"] as String,
      firstName: json["firstName"] as String,
      lastName: json["lastName"] as String,
      birthDate: DateTime.fromMillisecondsSinceEpoch(json["birthDate"]),
      zone: ZoneModel.fromJson(json["zone"]),
      activity: ActivityModel.fromJson(json["activity"]),
      company: CompanyModel.fromJson(json["company"]),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json["createdAt"]),
      portrait: json["portrait"] as String?,
      description: json["portrait"] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'birthDate': birthDate.toIso8601String(),
      'zone': zone.toJson(),
      'activity': activity.toJson(),
      'company': company.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'portrait': portrait,
      'description': description,
    };
  }
}
