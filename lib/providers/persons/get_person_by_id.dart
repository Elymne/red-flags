import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/core/exceptions/bad_response_exception.dart';
import 'package:red_flags/core/exceptions/network_exception.dart';
import 'package:red_flags/models/detailed_person.model.dart';

/// Provides details about one person.
/// Fetch from server given the args : GetDetailedPersonProviderParams.
///   - Calling route API : (get) /persons/{id}.
final Map<GetDetailedPersonProviderParams, DetailedPerson> _cached = {};
Timer? _timer;

final getDetailedPersonProvider = FutureProvider.autoDispose.family<DetailedPerson, GetDetailedPersonProviderParams>((ref, params) async {
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

  /// * http request.
  final response = await Dio().get<String>("${dotenv.env["HOST"]}/persons/${params.id}");

  /// * Check response code.
  if (response.statusCode != 200) {
    throw NetworkException(code: response.statusCode!, expected: 200);
  }

  /// * Check data type.
  if (response.data == null) {
    throw BadResponseException(type: response.data.runtimeType, expected: String);
  }

  /// * Parse response data.
  final Map<String, dynamic> jsonData = jsonDecode(response.data!);
  final DetailedPerson detailedPerson = DetailedPerson.fromJson(jsonData);

  /// * Cache result.
  _cached[params] = detailedPerson;

  /// * Return result.
  return detailedPerson;
});

class GetDetailedPersonProviderParams {
  final String id;
  GetDetailedPersonProviderParams({required this.id});
}
