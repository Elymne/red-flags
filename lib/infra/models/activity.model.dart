import 'package:red_flags/domain/entities/activity.entity.dart';

class ActivityModel {
  final String id;
  final String name;

  ActivityModel({required this.id, required this.name});

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(id: json['ID'] as String, name: json['name'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'ID': id, 'name': name};
  }

  factory ActivityModel.fromEntity(Activity entity) {
    return ActivityModel(id: entity.id, name: entity.name);
  }

  Activity toEntity() {
    return Activity(id: id, name: name);
  }
}
