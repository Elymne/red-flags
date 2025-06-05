import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/core/results/either.dart';
import 'package:red_flags/core/results/failure.dart';
import 'package:red_flags/core/results/success.dart';
import 'package:red_flags/infra/models/person.model.dart';

final remotePersonDatasourceProvider = Provider((ref) {
  return RemotePersonDatasource(dio: Dio());
});

class RemotePersonDatasource {
  final Dio _dio;

  RemotePersonDatasource({required Dio dio}) : _dio = dio;

  Future<Either<FailureType, List<PersonModel>>> fetchMany({
    String? firstname,
    String? lastname,
    DateTime? birthDate,
    String? zoneID,
    String? activityID,
    String? companyID,
  }) async {
    try {
      final response = await _dio.get<String>(
        "${dotenv.env["HOST"]}/persons",
        queryParameters: {
          if (firstname != null && firstname.isNotEmpty) "firstname": firstname,
          if (lastname != null && lastname.isNotEmpty) "lastname": lastname,
          if (birthDate != null) "birthDate": birthDate.microsecondsSinceEpoch,
          if (zoneID != null && zoneID.isNotEmpty) "zoneID": zoneID,
          if (activityID != null && activityID.isNotEmpty) "activityID": activityID,
          if (companyID != null && companyID.isNotEmpty) "companyID": companyID,
        },
      );

      if (response.statusCode != 200) {
        return Failure(FailureType.network);
      }

      if (response.data == null) {
        return Failure(FailureType.network);
      }

      final List<dynamic> raw = jsonDecode(response.data!)["data"];
      final persons = raw.cast<Map<String, dynamic>>().map((json) => PersonModel.fromJson(json)).toList();

      return Success(persons);
    } catch (err) {
      return Failure(FailureType.exception);
    }
  }

  Future<Either<FailureType, PersonModel>> fetchOnebyID(String id) async {
    try {
      final response = await _dio.get<String>("${dotenv.env["HOST"]}/persons/$id");

      if (response.statusCode != 200) {
        return Failure(FailureType.network);
      }

      if (response.data == null) {
        return Failure(FailureType.network);
      }

      final Map<String, dynamic> raw = jsonDecode(response.data!)["data"];
      final person = PersonModel.fromJson(raw);

      return Success(person);
    } catch (err) {
      return Failure(FailureType.exception);
    }
  }

  Future<Either<FailureType, Null>> addOne({
    required String firstname,
    required String lastname,
    required DateTime birthDate,
    required String zoneID,
    required String activityID,
    required String companyID,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        "${dotenv.env["HOST"]}/persons",
        data: {
          firstname: firstname,
          lastname: lastname,
          birthDate: birthDate.microsecondsSinceEpoch,
          zoneID: zoneID,
          activityID: activityID,
          companyID: companyID,
        },
      );

      if (response.statusCode != 200) {
        return Failure(FailureType.network);
      }

      return Success(null);
    } catch (err) {
      return Failure(FailureType.exception);
    }
  }
}
