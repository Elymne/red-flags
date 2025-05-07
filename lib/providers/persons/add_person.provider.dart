import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/core/exceptions/bad_response_exception.dart';
import 'package:red_flags/core/exceptions/bad_user_input_exception.dart';
import 'package:red_flags/core/exceptions/network_exception.dart';
import 'package:red_flags/core/extensions/list_extension.dart';
import 'package:red_flags/models/zone.model.dart';

/// Provide an action to add a new person to server.
/// Fetch from server given the args : AddPersonProviderParams.
///   - Calling route API : (post) /persons.
final addPersonProvider = FutureProvider.autoDispose.family<void, AddPersonProviderParams>((ref, params) async {
  /// * Get zones by name.
  final zonesResponse = await Dio().post<String>("${dotenv.env["HOST"]}/zones", data: {"name": params.zonename});

  /// * Check zones response code.
  if (zonesResponse.statusCode != 200) {
    throw NetworkException(code: zonesResponse.statusCode!, expected: 200);
  }

  /// * Check zones response data.
  if (zonesResponse.data == null) {
    throw BadResponseException(type: zonesResponse.data.runtimeType, expected: String);
  }

  /// * Parse json data.
  final zones = (jsonDecode(zonesResponse.data!) as List).cast<Map<String, dynamic>>().map((json) => Zone.fromJson(json)).toList();

  /// * Find unique occurance.
  final zone = zones.firstWhereOrNull((zone) => zone!.name == params.zonename);

  /// * Check that the exact name string exists.
  if (zone == null) {
    throw BadUserInputException(details: "The zone ${params.zonename} doesn't exists");
  }

  /// * http request.
  final response = await Dio().post<String>(
    "${dotenv.env["HOST"]}/persons",
    data: {"firstname": params.firstname, "lastname": params.lastname, "jobname": params.jobname, "zoneid": zone.id},
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
