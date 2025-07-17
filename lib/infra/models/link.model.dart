import 'package:red_flags/domain/entities/link.entity.dart';

class LinkModel {
  final String id;
  final String value;

  LinkModel({required this.id, required this.value});

  factory LinkModel.fromJson(Map<String, dynamic> json) {
    return LinkModel(id: json['ID'] as String, value: json['value'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'ID': id, 'value': value};
  }

  static LinkModel fromEntity(Link entity) {
    return LinkModel(id: entity.id, value: entity.value);
  }

  Link toEntity() {
    return Link(id: id, value: value);
  }
}
