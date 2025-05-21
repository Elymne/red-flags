import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/core/exceptions/bad_response_exception.dart';
import 'package:red_flags/core/exceptions/network_exception.dart';

final addPersonProvider = FutureProvider.autoDispose.family<void, AddPersonProviderParams>((ref, params) async {
  /// * Get zones by name.
  final response = await Dio().post<String>(
    "${dotenv.env["HOST"]}/persons",
    data: {
      "firstname": params.firstname,
      "lastname": params.lastname,
      "birthDate": params.birthDate.millisecondsSinceEpoch,
      "zoneID": params.zoneID,
      "activityID": params.activityID,
      "companyID": params.companyID,
    },
  );

  /// * Check zones response code.
  if (response.statusCode != 201) {
    throw NetworkException(code: response.statusCode!, expected: 200);
  }

  /// * Check zones response data.
  if (response.data == null) {
    throw BadResponseException(type: response.data.runtimeType, expected: String);
  }
});

class AddPersonProviderParams {
  final String firstname;
  final String lastname;
  final DateTime birthDate;
  final String zoneID;
  final String companyID;
  final String activityID;
  AddPersonProviderParams({
    required this.firstname,
    required this.lastname,
    required this.birthDate,
    required this.zoneID,
    required this.companyID,
    required this.activityID,
  });
}
