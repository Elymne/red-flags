import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/models/detailed_person.model.dart';
import 'package:red_flags/providers/provider_value.dart';

/// Provides a unique detailed person (person + messages, links and cursors).
/// Function searchBy to fetch data from server given the ID.
///   - Calling route API : (get) /persons/{id}.
///   - Return null when data is not found.
final getDetailedPersonProvider = StateNotifierProvider<_Notifier, _Result>((ref) {
  return _Notifier(ref);
});

class _Notifier extends StateNotifier<_Result> {
  final Ref ref;

  _Notifier(this.ref) : super(_Result(state: ProviderState.init, data: null));

  Future<void> fetchUnique(String id) async {
    try {
      state = _Result(state: ProviderState.loading, data: null);
      final response = await Dio().get<String>("${dotenv.env["HOST"]}/persons/$id");

      if (response.statusCode != 200 || response.data == null) {
        state = _Result(state: ProviderState.failure, data: null);
        return;
      }

      final DetailedPerson decodedValues = jsonDecode(response.data!);
      state = _Result(state: ProviderState.success, data: decodedValues);
    } catch (err) {
      if (kDebugMode) print(err);
      state = _Result(state: ProviderState.exception, data: null);
    }
  }
}

class _Result extends ProviderValue<DetailedPerson?> {
  _Result({required super.state, required super.data});
}
