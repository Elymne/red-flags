import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/models/person.model.dart';
import 'package:dio/dio.dart';
import 'package:red_flags/providers/provider_value.dart';

/// Provider for list of person given firstname, lastname, job name and zone name (city).
/// Used in :
///  - HomeScreen widget.
final searchPersonsProvider = StateNotifierProvider<_Notifier, _Value>((ref) {
  return _Notifier(ref);
});

/// Usecase : search for persons given the firstname, lastname, job name and zone name (city).
/// Calling route API : (get) /persons.
/// Data response structure : List of Persons.
class _Notifier extends StateNotifier<_Value> {
  final Ref ref;

  _Notifier(this.ref) : super(_Value(state: ProviderState.init, value: []));

  Future search({String? firstname, String? lastname, String? zoneName, String? jobname}) async {
    try {
      // Update state : Searching (load time).
      state = _Value(state: ProviderState.init, value: []);
      final response = await Dio().get<List>(
        "${dotenv.env["HOST"]}/persons",
        queryParameters: {"firstname": firstname, "lastname": lastname, "zonename": zoneName, "jobname": jobname},
      );
      // Checking response code.
      if (response.statusCode != 200 || response.data == null) {
        // Update state : Failure (The response code isn't 200).
        state = _Value(state: ProviderState.failure, value: []);
        return;
      }
      // Update state : Success.
      state = _Value(state: ProviderState.success, value: response.data!.map((elem) => Person.fromJson(elem)).toList());
    } catch (err) {
      // Update state : Failure (Exception thrown).
      state = _Value(state: ProviderState.failure, value: []);
    }
  }
}

/// List of Persons.
class _Value extends ProviderValue<List<Person>> {
  _Value({required super.state, required super.value});
}
