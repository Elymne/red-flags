import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/providers/provider_value.dart';

/// Provides the creation of unique person..
/// Function addUnique to add a new person.
///   - Calling route API : (post) /persons.
final addPersonProvider = StateNotifierProvider<_Notifier, _Result>((ref) {
  return _Notifier(ref);
});

class _Notifier extends StateNotifier<_Result> {
  final Ref ref;

  _Notifier(this.ref) : super(_Result(state: ProviderState.init, data: null));

  Future<void> addUnique(String firstName, String lastName, String jobName, String zoneID) async {
    try {
      state = _Result(state: ProviderState.loading, data: state.data);
      final response = await Dio().post<String>(
        "${dotenv.env["HOST"]}/persons",
        data: {"firstname": firstName, "lastname": lastName, "jobname": jobName, "zoneid": zoneID},
      );

      if (response.statusCode != 201 || response.data == null) {
        state = _Result(state: ProviderState.failure, data: null);
        return;
      }

      state = _Result(state: ProviderState.success);
    } catch (err) {
      state = _Result(state: ProviderState.exception, data: null);
    }
  }
}

/// Result state.
class _Result extends ProviderValue<void> {
  _Result({required super.state, super.data});
}
