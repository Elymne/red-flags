import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/core/result/either.dart';
import 'package:red_flags/core/result/failure.dart';
import 'package:red_flags/core/result/success.dart';

import 'package:red_flags/infra/models/activity.model.dart';

final remoteActivityDatasourceProvider = Provider((ref) {
  return RemoteActivityDatasource(dio: Dio());
});

class RemoteActivityDatasource {
  final Dio _dio;

  RemoteActivityDatasource({required Dio dio}) : _dio = dio;

  Future<Either<FailureType, List<ActivityModel>>> fetchManyByName(String activityName) async {
    try {
      final response = await _dio.get<String>("${dotenv.env["HOST"]}/activities", queryParameters: {"name": activityName});

      if (response.statusCode != 200) {
        return Failure(FailureType.network);
      }

      if (response.data == null) {
        return Failure(FailureType.network);
      }

      final List<dynamic> raw = jsonDecode(response.data!)["data"];
      final activities = raw.cast<Map<String, dynamic>>().map((json) => ActivityModel.fromJson(json)).toList();

      return Success(activities);
    } catch (err) {
      return Failure(FailureType.exception);
    }
  }

  Future<Either<FailureType, ActivityModel>> fetchOneByID(String id) async {
    try {
      final response = await _dio.get<String>("${dotenv.env["HOST"]}/activities/$id");

      if (response.statusCode != 200) {
        return Failure(FailureType.network);
      }

      if (response.data == null) {
        return Failure(FailureType.network);
      }

      final Map<String, dynamic> raw = jsonDecode(response.data!)["data"];
      final activity = ActivityModel.fromJson(raw);

      return Success(activity);
    } catch (err) {
      return Failure(FailureType.exception);
    }
  }
}
