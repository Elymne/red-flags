class Person {
  final String id;
  final String firstName;
  final String lastName;
  final String cityName;
  final String jobName;
  final DateTime createdDate;
  final DateTime? updatedDate;

  Person({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.cityName,
    required this.jobName,
    required this.createdDate,
    this.updatedDate,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json["id"] as String,
      firstName: json["firstName"] as String,
      lastName: json["lastName"] as String,
      cityName: json["cityName"] as String,
      jobName: json["jobname"] as String,
      createdDate: DateTime.parse(json["createdDate"]),
      updatedDate: DateTime.parse(json["updatedDate"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "firstName": firstName,
      "lastName": lastName,
      "cityName": cityName,
      "jobname": jobName,

      "createdDate": createdDate.toIso8601String(),
      "updatedDate": updatedDate?.toIso8601String(),
    };
  }
}
