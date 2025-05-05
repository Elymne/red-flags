class NetworkException implements Exception {
  final int code;
  final int expected;

  NetworkException({required this.code, required this.expected});

  @override
  String toString() => '''
    NetworkException: Network error while fetching data from the server.
    Response code expected : $expected. $code received instead. 
  ''';
}
