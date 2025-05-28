class BadUserInputException implements Exception {
  final String details;

  BadUserInputException({required this.details});

  @override
  String toString() => '''
    BadUserInputException: Bad user input used for the current action.
    Action was : $details
  ''';
}
