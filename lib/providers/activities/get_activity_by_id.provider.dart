import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/core/exceptions/bad_response_exception.dart';
import 'package:red_flags/core/exceptions/network_exception.dart';
import 'package:red_flags/models/activity.model.dart';
import 'package:red_flags/providers/response.model.dart';

final Map<GetActivityByIdProviderParams, Activity> _cached = {};
Timer? _timer;

final getActivityByIdProvider = FutureProvider.autoDispose.family<Activity, GetActivityByIdProviderParams>((ref, params) async {
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
  final response = await Dio().get<String>("${dotenv.env["HOST"]}/activities/${params.id}");

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
  final activity = Activity.fromJson(raw.data);

  /// * Cache result.
  _cached[params] = activity;

  /// * Return activities fetched.
  return activity;
});

class GetActivityByIdProviderParams {
  final String id;
  GetActivityByIdProviderParams({required this.id});
}
