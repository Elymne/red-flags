import "package:red_flags/models/person.model.dart";

class DetailedPerson extends Person {
  final List<String> messages;
  final List<String> links;

  DetailedPerson({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.birthday,
    required super.zoneName,
    required super.jobName,

    required super.createdAt,
    super.updatedAt,
    super.portrait,

    required this.messages,
    required this.links,
  });

  factory DetailedPerson.fromJson(Map<String, dynamic> json) {
    return DetailedPerson(
      id: json["id"] as String,
      firstName: json["firstName"] as String,
      lastName: json["lastName"] as String,
      birthday: DateTime.fromMillisecondsSinceEpoch(json["birthday"]),
      zoneName: json["zone"]["name"] as String,
      jobName: json["jobName"] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json["createdAt"]),

      messages: List<String>.from(json["messages"] as List),
      links: List<String>.from(json["links"] as List),

      /// * Nullable.
      updatedAt: json["updatedAt"] ? DateTime.fromMillisecondsSinceEpoch(json["updatedAt"]) : null,
      portrait: json["portrait"],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "firstName": firstName,
      "lastName": lastName,
      "birthname": birthday,
      "zoneName": zoneName,
      "jobName": jobName,

      "createdAt": createdAt.toIso8601String(),
      "updatedAt": createdAt.toIso8601String(),

      "messages": messages,
      "links": links,
    };
  }
}
