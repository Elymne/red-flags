import 'dart:convert';

class Person {
  final String id;
  final String firstName;
  final String lastName;
  final DateTime createdDate;
  final DateTime? updatedDate;
  final String cityName;

  Person({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.createdDate,
    this.updatedDate,
    required this.cityName,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      createdDate: DateTime.parse(json['createdDate']),
      updatedDate: DateTime.parse(json['updatedDate']),
      cityName: json['cityName'],
    );
  }

  static List<Person> fromJsonList(String jsonString) {
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => Person.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'createdDate': createdDate.toIso8601String(),
      'updatedDate': updatedDate?.toIso8601String(),
      'cityName': cityName,
    };
  }
}
