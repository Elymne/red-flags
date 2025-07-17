import 'package:red_flags/domain/entities/zone.entity.dart';

class ZoneModel {
  final String id;
  final String name;

  ZoneModel({required this.id, required this.name});

  factory ZoneModel.fromJson(Map<String, dynamic> json) {
    return ZoneModel(id: json['ID'] as String, name: json['name'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'ID': id, 'name': name};
  }

  factory ZoneModel.fromEntity(Zone entity) {
    return ZoneModel(id: entity.id, name: entity.name);
  }

  Zone toEntity() {
    return Zone(id: id, name: name);
  }
}
