class SearchPersonFormState {
  String _firstname = "";
  String get firstname => _firstname;

  String _lastname = "";
  String get lastname => _lastname;

  DateTime? _birthDate;
  DateTime? get birthDate => _birthDate;

  String _zoneID = "";
  String get zoneID => _zoneID;

  String _activityID = "";
  String get activityID => _activityID;

  String _companyID = "";
  String get companyID => _companyID;

  void updateValues({
    String? firstname,
    String? lastname,
    DateTime? birthDate,
    String? zoneName,
    String? activityName,
    String? companyName,
  }) {
    _firstname = firstname ?? _firstname;
    _lastname = lastname ?? _lastname;
    _birthDate = birthDate ?? _birthDate;
    _zoneID = zoneName ?? _zoneID;
    _activityID = activityName ?? _activityID;
    _companyID = companyName ?? _companyID;
  }
}
