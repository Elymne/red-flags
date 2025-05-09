class Person {
  final String id;
  final String firstname;
  final String lastname;
  final DateTime birthday;
  final String zonename;
  final String jobname;

  final DateTime createdDate;
  final DateTime? updatedDate;

  Person({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.birthday,
    required this.zonename,
    required this.jobname,
    required this.createdDate,
    this.updatedDate,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json["id"] as String,
      firstname: json["firstName"] as String,
      lastname: json["lastName"] as String,

      /// TODO : Waiting backend changes.
      birthday: DateTime.now(),

      zonename: json["cityName"] as String,
      jobname: json["jobname"] as String,
      createdDate: DateTime.parse(json["createdDate"]),
      updatedDate: DateTime.parse(json["updatedDate"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "firstName": firstname,
      "lastName": lastname,
      "birthday": birthday,
      "cityName": zonename,
      "jobname": jobname,

      "createdDate": createdDate.toIso8601String(),
      "updatedDate": updatedDate?.toIso8601String(),
    };
  }
}
