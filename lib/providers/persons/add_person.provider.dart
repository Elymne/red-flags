import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/core/exceptions/network_exception.dart';

/// Provide an action to add a new person to server.
/// Fetch from server given the args : AddPersonProviderParams.
///   - Calling route API : (post) /persons.
final addPersonProvider = FutureProvider.autoDispose.family<void, AddPersonProviderParams>((ref, params) async {
  /// TODO : Find zone id by name
  final zoneID = "";

  /// * http request.
  final response = await Dio().post<String>(
    "${dotenv.env["HOST"]}/persons",
    data: {"firstname": params.firstname, "lastname": params.lastname, "jobname": params.jobname, "zoneid": zoneID},
  );

  /// * Check response code.
  if (response.statusCode != 201) {
    throw NetworkException(code: response.statusCode!, expected: 201);
  }
});

class AddPersonProviderParams {
  final String firstname;
  final String lastname;
  final String jobname;
  final String zonename;

  AddPersonProviderParams({required this.firstname, required this.lastname, required this.jobname, required this.zonename});
}
