import 'package:red_flags/domain/entities/company.entity.dart';

class CompanyModel {
  final String id;
  final String name;
  final String address;

  CompanyModel({required this.id, required this.name, required this.address});

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(id: json['ID'] as String, name: json['name'] as String, address: json['address'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'ID': id, 'name': name, 'address': address};
  }

  // Assuming you have a CompanyEntity class defined elsewhere
  factory CompanyModel.fromEntity(Company entity) {
    return CompanyModel(id: entity.id, name: entity.name, address: entity.address);
  }

  Company toEntity() {
    return Company(id: id, name: name, address: address);
  }
}
