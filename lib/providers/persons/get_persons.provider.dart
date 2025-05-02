import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/models/person.model.dart';
import 'package:dio/dio.dart';
import 'package:red_flags/providers/provider_value.dart';

/// Provides list of persons.
/// Function searchBy to fetch data from server given the firstname, lastname, zonename and jobname.
///   - Calling route API : (get) /persons.
final getPersonsProvider = StateNotifierProvider<_Notifier, _Result>((ref) {
  return _Notifier(ref);
});

class _Notifier extends StateNotifier<_Result> {
  final Ref ref;

  _Notifier(this.ref) : super(_Result(state: ProviderState.init, data: []));

  Future<void> searchBy({required String firstName, required String lastName, required String zoneName, required String jobName}) async {
    try {
      if (firstName.isEmpty && lastName.isEmpty && zoneName.isEmpty && jobName.isEmpty) {
        state = _Result(state: ProviderState.success, data: []);
        return;
      }

      state = _Result(state: ProviderState.loading, data: []);
      final response = await Dio().get<String>(
        "${dotenv.env["HOST"]}/persons",
        queryParameters: {"firstname": firstName, "lastname": lastName, "zonename": zoneName, "jobname": jobName},
      );

      if (response!.statusCode != 200 || response!.data == null) {
        state = _Result(state: ProviderState.failure, data: []);
        return;
      }

      final List<Person> decodedValues =
          (jsonDecode(response!.data!) as List).cast<Map<String, dynamic>>().map((json) => Person.fromJson(json)).toList();
      state = _Result(state: ProviderState.success, data: decodedValues);
    } catch (err) {
      if (kDebugMode) print(err);
      state = _Result(state: ProviderState.exception, data: []);
    }
  }
}

class _Result extends ProviderValue<List<Person>> {
  _Result({required super.state, required super.data});
}
