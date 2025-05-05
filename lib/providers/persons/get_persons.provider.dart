import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/core/exceptions/bad_response_exception.dart';
import 'package:red_flags/core/exceptions/network_exception.dart';
import 'package:red_flags/models/person.model.dart';

final Map<GetPersonsProviderParams, List<Person>> _cached = {};
Timer? _timer;

/// Provides list of persons.
/// Fetch from server given the args : GetPersonsProviderParams.
///   - Calling route API : (get) /persons.
final getPersonsProvider = FutureProvider.autoDispose.family<List<Person>, GetPersonsProviderParams>((ref, params) async {
  /// * Check if we should clear the cache or not.
  if (_timer != null) {
    _timer = Timer(Duration(milliseconds: 10_000), () {
      _cached.clear();
      _timer = null;
    });
  }

  /// * Check if cached data exists. Return if it's the case.
  final cached = _cached[params];
  if (cached != null) {
    return cached;
  }

  /// * Make http request.
  final response = await Dio().get<String>(
    "${dotenv.env["HOST"]}/persons",
    queryParameters: {"firstname": params.firstname, "lastname": params.lastname, "zonename": params.zonename, "jobname": params.jobname},
  );

  /// * Check response code.
  if (response.statusCode != 200) {
    throw NetworkException(code: response.statusCode!, expected: 200);
  }

  /// * Check data type.
  if (response.data == null) {
    throw BadResponseException(type: response.data.runtimeType, expected: String);
  }

  /// * Parse json data.
  final persons = (jsonDecode(response.data!) as List).cast<Map<String, dynamic>>().map((json) => Person.fromJson(json)).toList();

  /// * Cache result.
  _cached[params] = persons;

  /// * Return result.
  return persons;
});

class GetPersonsProviderParams {
  final String firstname;
  final String lastname;
  final String zonename;
  final String jobname;
  GetPersonsProviderParams({required this.firstname, required this.lastname, required this.zonename, required this.jobname});
}
