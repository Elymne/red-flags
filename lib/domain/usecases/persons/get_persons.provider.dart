import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/core/exceptions/bad_response_exception.dart';
import 'package:red_flags/core/exceptions/network_exception.dart';
import 'package:red_flags/domain/models/person.model.dart';
import 'package:red_flags/domain/usecases/response.model.dart';

final getPersonsProvider = FutureProvider.autoDispose.family<List<Person>, GetPersonsProviderParams>((ref, params) async {
  /// * Make http request.
  final response = await Dio().get<String>(
    "${dotenv.env["HOST"]}/persons",
    queryParameters: {
      if (params.firstname != null && params.firstname!.isNotEmpty) "firstname": params.firstname,
      if (params.lastname != null && params.lastname!.isNotEmpty) "lastname": params.lastname,
      if (params.birthDate != null && params.birthDate!.isNotEmpty) "birthDate": params.birthDate,
      if (params.zoneID != null && params.zoneID!.isNotEmpty) "jobname": params.zoneID,
      if (params.activityID != null && params.activityID!.isNotEmpty) "jobname": params.activityID,
      if (params.companyID != null && params.companyID!.isNotEmpty) "jobname": params.companyID,
    },
  );

  /// * Check response code.
  if (response.statusCode != 200) {
    throw NetworkException(code: response.statusCode!, expected: 200);
  }

  /// * Check data type.
  if (response.data == null) {
    throw BadResponseException(type: response.data.runtimeType, expected: String);
  }

  /// * get resp
  final ResponseData<List> raw = jsonDecode(response.data!);

  /// * Parse json data.
  final persons = raw.data.cast<Map<String, dynamic>>().map((json) => Person.fromJson(json)).toList();

  /// * Return result.
  return persons;
});

class GetPersonsProviderParams {
  final String? firstname;
  final String? lastname;
  final String? birthDate;
  final String? zoneID;
  final String? activityID;
  final String? companyID;
  GetPersonsProviderParams({this.firstname, this.lastname, this.birthDate, this.zoneID, this.activityID, this.companyID});
}
