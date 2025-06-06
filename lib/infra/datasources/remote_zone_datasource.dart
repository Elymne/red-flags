import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/core/result/either.dart';
import 'package:red_flags/core/result/failure.dart';
import 'package:red_flags/core/result/success.dart';
import 'package:red_flags/infra/datasources/datasource_failure.enum.dart';
import 'package:red_flags/infra/models/zone.model.dart';

final remoteZoneDatasourceProvider = Provider((ref) {
  return RemoteZoneDatasource(dio: Dio());
});

class RemoteZoneDatasource {
  final Dio _dio;

  RemoteZoneDatasource({required Dio dio}) : _dio = dio;

  Future<Either<DatasourceFailure, List<ZoneModel>>> fetchManyByName(String zoneName) async {
    try {
      final response = await _dio.get<String>("${dotenv.env["HOST"]}/zones", queryParameters: {"name": zoneName});

      if (response.statusCode != 200) {
        return Failure(DatasourceFailure.network);
      }

      if (response.data == null) {
        return Failure(DatasourceFailure.wrongResult);
      }

      final List<dynamic> raw = jsonDecode(response.data!)["data"];
      final zones = raw.cast<Map<String, dynamic>>().map((json) => ZoneModel.fromJson(json)).toList();

      return Success(zones);
    } catch (err) {
      return Failure(DatasourceFailure.exception);
    }
  }

  Future<Either<DatasourceFailure, ZoneModel>> fetchOneByID(String id) async {
    try {
      final response = await _dio.get<String>("${dotenv.env["HOST"]}/zones/$id");

      if (response.statusCode != 200) {
        return Failure(DatasourceFailure.network);
      }

      if (response.data == null) {
        return Failure(DatasourceFailure.wrongResult);
      }

      final Map<String, dynamic> raw = jsonDecode(response.data!)["data"];
      final activity = ZoneModel.fromJson(raw);

      return Success(activity);
    } catch (err) {
      return Failure(DatasourceFailure.exception);
    }
  }
}
