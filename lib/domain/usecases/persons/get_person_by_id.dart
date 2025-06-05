import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/core/exceptions/bad_response_exception.dart';
import 'package:red_flags/core/exceptions/network_exception.dart';
import 'package:red_flags/domain/models/person.model.dart';
import 'package:red_flags/domain/usecases/response.model.dart';

final Map<GetPersonByIdParams, Person> _cached = {};
Timer? _timer;

final getPersonByID = FutureProvider.autoDispose.family<Person, GetPersonByIdParams>((ref, params) async {
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

  /// * get resp
  final ResponseData<Map<String, dynamic>> raw = jsonDecode(response.data!);

  /// * Parse json data.
  final person = Person.fromJson(raw.data);

  /// * Cache result.
  _cached[params] = person;

  /// * Return result.
  return person;
});

class GetPersonByIdParams {
  final String id;
  GetPersonByIdParams({required this.id});
}
