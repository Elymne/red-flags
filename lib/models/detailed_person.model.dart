import "package:red_flags/models/person.model.dart";

class DetailedPerson extends Person {
  final List<String> messages;
  final List<String> links;

  DetailedPerson({
    required super.id,
    required super.firstname,
    required super.lastname,
    required super.birthday,
    required super.zonename,
    required super.jobname,

    required super.createdDate,
    super.updatedDate,

    required this.messages,
    required this.links,
  });

  factory DetailedPerson.fromJson(Map<String, dynamic> json) {
    return DetailedPerson(
      id: json["id"] as String,
      firstname: json["firstname"] as String,
      lastname: json["lastname"] as String,
      birthday: DateTime.now(),
      zonename: json["cityname"] as String,
      jobname: json["jobname"] as String,

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
      "firstname": firstname,
      "lastname": lastname,
      "birthname": birthday,
      "zonename": zonename,
      "jobname": jobname,

      "createdAt": createdDate.toIso8601String(),
      "updatedAt": createdDate.toIso8601String(),

      "messages": messages,
      "links": links,
    };
  }
}
