import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/core/exceptions/bad_response_exception.dart';
import 'package:red_flags/core/exceptions/network_exception.dart';
import 'package:red_flags/domain/models/activity.model.dart';

final getActivitiesProvider = FutureProvider.autoDispose.family<List<Activity>, GetActivitiesProviderParams>((ref, params) async {
  final response = await Dio().get<String>("${dotenv.env["HOST"]}/activities", queryParameters: {"name": params.activityName});

  if (response.statusCode != 200) {
    throw NetworkException(code: response.statusCode!, expected: 200);
  }

  if (response.data == null) {
    throw BadResponseException(type: response.data.runtimeType, expected: String);
  }

  final List<dynamic> raw = jsonDecode(response.data!)["data"];
  final activities = raw.cast<Map<String, dynamic>>().map((json) => Activity.fromJson(json)).toList();

  return activities;
});

class GetActivitiesProviderParams {
  final String activityName;
  GetActivitiesProviderParams({required this.activityName});
}
