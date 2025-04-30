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

  Future<void> search({required String firstname, required String lastname, required String zoneName, required String jobname}) async {
    try {
      /// Check that at least one value is not empty else set empty list as result.
      if (firstname.isEmpty && lastname.isEmpty && zoneName.isEmpty && jobname.isEmpty) {
        state = _Value(state: ProviderState.success, value: []);
        return;
      }

      /// Update state : Searching (load time).
      state = _Value(state: ProviderState.init, value: []);
      final response = await Dio().get<String>(
        "${dotenv.env["HOST"]}/persons",
        queryParameters: {"firstname": firstname, "lastname": lastname, "zonename": zoneName, "jobname": jobname},
      );

      /// Checking response code.
      if (response.statusCode != 200 || response.data == null) {
        /// Update state : Failure (The response code isn't 200).
        state = _Value(state: ProviderState.failure, value: []);
        return;
      }

      /// Update state : Success.
      state = _Value(state: ProviderState.success, value: Person.fromJsonList(response.data!));
    } catch (err) {
      print(err);

      /// Update state : Failure (Exception thrown).
      state = _Value(state: ProviderState.failure, value: []);
    }
  }
}

/// List of Persons.
class _Value extends ProviderValue<List<Person>> {
  _Value({required super.state, required super.value});
}
