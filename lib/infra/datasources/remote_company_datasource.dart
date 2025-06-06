import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/core/result/either.dart';
import 'package:red_flags/core/result/failure.dart';
import 'package:red_flags/core/result/success.dart';
import 'package:red_flags/infra/datasources/datasource_failure.enum.dart';
import 'package:red_flags/infra/models/company.model.dart';

final remoteCompanyDatasourceProvider = Provider((ref) {
  return RemoteCompanyDatasource(dio: Dio());
});

class RemoteCompanyDatasource {
  final Dio _dio;

  RemoteCompanyDatasource({required Dio dio}) : _dio = dio;

  Future<Either<DatasourceFailure, List<CompanyModel>>> fetchManyByName(String companyName) async {
    try {
      final response = await _dio.get<String>("${dotenv.env["HOST"]}/companies", queryParameters: {"name": companyName});

      if (response.statusCode != 200) {
        return Failure(DatasourceFailure.network);
      }

      if (response.data == null) {
        return Failure(DatasourceFailure.wrongResult);
      }

      final List<dynamic> raw = jsonDecode(response.data!)["data"];
      final activities = raw.cast<Map<String, dynamic>>().map((json) => CompanyModel.fromJson(json)).toList();

      return Success(activities);
    } catch (err) {
      return Failure(DatasourceFailure.exception);
    }
  }

  Future<Either<DatasourceFailure, CompanyModel>> fetchOneByID(String id) async {
    try {
      final response = await _dio.get<String>("${dotenv.env["HOST"]}/companies/$id");

      if (response.statusCode != 200) {
        return Failure(DatasourceFailure.network);
      }

      if (response.data == null) {
        return Failure(DatasourceFailure.wrongResult);
      }

      final Map<String, dynamic> raw = jsonDecode(response.data!)["data"];
      final activity = CompanyModel.fromJson(raw);

      return Success(activity);
    } catch (err) {
      return Failure(DatasourceFailure.exception);
    }
  }
}
