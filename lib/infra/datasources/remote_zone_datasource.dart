import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/core/result/either.dart';
import 'package:red_flags/core/result/failure.dart';
import 'package:red_flags/core/result/failure_type.dart';
import 'package:red_flags/core/result/success.dart';
import 'package:red_flags/infra/models/zone.model.dart';

final remoteZoneDatasourceProvider = Provider((ref) {
  return RemoteZoneDatasource(dio: Dio());
});

class RemoteZoneDatasource {
  final Dio _dio;

  RemoteZoneDatasource({required Dio dio}) : _dio = dio;

  Future<Either<FailureType, List<ZoneModel>>> fetchManyByName(String zoneName) async {
    try {
      final response = await _dio.get<String>("${dotenv.env["HOST"]}/zones", queryParameters: {"name": zoneName});

      if (response.statusCode != 200) {
        return Failure(FailureType.network);
      }

      if (response.data == null) {
        return Failure(FailureType.network);
      }

      final List<dynamic> raw = jsonDecode(response.data!)["data"];
      final zones = raw.cast<Map<String, dynamic>>().map((json) => ZoneModel.fromJson(json)).toList();

      return Success(zones);
    } catch (err) {
      return Failure(FailureType.exception);
    }
  }

  Future<Either<FailureType, ZoneModel>> fetchOneByID(String id) async {
    try {
      final response = await _dio.get<String>("${dotenv.env["HOST"]}/zones/$id");

      if (response.statusCode != 200) {
        return Failure(FailureType.network);
      }

      if (response.data == null) {
        return Failure(FailureType.network);
      }

      final Map<String, dynamic> raw = jsonDecode(response.data!)["data"];
      final activity = ZoneModel.fromJson(raw);

      return Success(activity);
    } catch (err) {
      return Failure(FailureType.exception);
    }
  }
}
