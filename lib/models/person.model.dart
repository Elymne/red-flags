class Person {
  final String id;
  final String firstName;
  final String lastName;
  final DateTime birthday;
  final String zoneName;
  final String jobName;

  final DateTime createdAt;

  final String? portrait;
  final DateTime? updatedAt;

  Person({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.birthday,
    required this.zoneName,
    required this.jobName,
    required this.createdAt,
    this.updatedAt,
    this.portrait,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json["id"] as String,
      firstName: json["firstName"] as String,
      lastName: json["lastName"] as String,
      birthday: DateTime.fromMillisecondsSinceEpoch(json["birthday"]),

      zoneName: json["zone"]["name"] as String,
      jobName: json["jobName"] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json["createdAt"]),

      /// * Nullable.
      updatedAt: json["updatedAt"] != null ? DateTime.fromMillisecondsSinceEpoch(json["updatedAt"]) : null,
      portrait: json["portrait"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "firstName": firstName,
      "lastName": lastName,
      "birthday": birthday,
      "jobName": jobName,
      "zoneName": zoneName,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
    };
  }
}
