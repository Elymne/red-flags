class BadResponseException implements Exception {
  final Type type;
  final Type expected;

  BadResponseException({required this.type, required this.expected});

  @override
  String toString() => '''
    BadResponseException: Bad response structure while fetching data from the server.
    Response data expected : $expected. $type received instead.
  ''';
}
