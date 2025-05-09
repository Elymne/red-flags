import "package:red_flags/models/person.model.dart";

class DetailedPerson extends Person {
  final List<String> messages;
  final List<String> links;

  DetailedPerson({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.birthday,
    required super.cityName,
    required super.jobName,

    required super.createdDate,
    super.updatedDate,

    required this.messages,
    required this.links,
  });

  factory DetailedPerson.fromJson(Map<String, dynamic> json) {
    return DetailedPerson(
      id: json["id"] as String,
      firstName: json["firstname"] as String,
      lastName: json["lastname"] as String,
      birthday: DateTime.now(),
      cityName: json["cityname"] as String,
      jobName: json["jobname"] as String,

      createdDate: DateTime.parse(json["createdAt"] as String),
      updatedDate: DateTime.parse(json["createdAt"] as String),

      messages: List<String>.from(json["messages"] as List),
      links: List<String>.from(json["links"] as List),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "firstname": firstName,
      "lastname": lastName,
      "birthname": birthday,
      "cityname": cityName,
      "jobname": jobName,

      "createdAt": createdDate.toIso8601String(),
      "updatedAt": createdDate.toIso8601String(),

      "messages": messages,
      "links": links,
    };
  }
}
