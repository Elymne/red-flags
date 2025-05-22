import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/core/exceptions/bad_response_exception.dart';
import 'package:red_flags/core/exceptions/network_exception.dart';
import 'package:red_flags/models/activity.model.dart';

final Map<GetActivitiesProviderParams, List<Activity>> _cached = {};
Timer? _timer;

final getActivitiesProvider = FutureProvider.autoDispose.family<List<Activity>, GetActivitiesProviderParams>((ref, params) async {
  /// * Check if we should clear the cache or not.
  if (_timer != null) {
    _timer = Timer(Duration(milliseconds: 10_000), () {
      _cached.clear();
      _timer = null;
    });
  }

  /// * Check if cached data exists. Return if it's teh case.
  final cached = _cached[params];
  if (cached != null) {
    return cached;
  }

  /// * Make http request.
  final response = await Dio().get<String>("${dotenv.env["HOST"]}/activities");

  /// * Check response code.
  if (response.statusCode != 200) {
    throw NetworkException(code: response.statusCode!, expected: 200);
  }

  /// * Check data type.
  if (response.data == null) {
    throw BadResponseException(type: response.data.runtimeType, expected: String);
  }

  /// * get resp
  final List<dynamic> raw = jsonDecode(response.data!)["data"];

  /// * Parse json data.
  final activities = raw.cast<Map<String, dynamic>>().map((json) => Activity.fromJson(json)).toList();

  /// * Cache result.
  _cached[params] = activities;

  /// * Return activities fetched.
  return activities;
});

class GetActivitiesProviderParams {
  GetActivitiesProviderParams();
}
