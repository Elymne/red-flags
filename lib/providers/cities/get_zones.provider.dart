import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/models/zone.model.dart';
import 'package:red_flags/providers/provider_value.dart';

/// Provides list of zones.
/// Function searchBy to fetch data from server given a zonename.
///   - Calling route API : (get) /zones/remote.
final getZonesProvider = StateNotifierProvider<_Notifier, _Result>((ref) {
  return _Notifier(ref);
});

class _Notifier extends StateNotifier<_Result> {
  final Ref ref;

  _Notifier(this.ref) : super(_Result(state: ProviderState.init, data: []));

  Future<void> searchBy(String zonename) async {
    try {
      if (zonename.isEmpty) {
        state = _Result(state: ProviderState.init, data: []);
        return;
      }

      state = _Result(state: ProviderState.loading, data: state.data); // Keep the old data while fetching !
      final response = await Dio().get<String>("${dotenv.env["HOST"]}/zones/remote", queryParameters: {"name": zonename});

      if (response.statusCode != 200 || response.data == null) {
        state = _Result(state: ProviderState.failure, data: []);
        return;
      }

      final List<Zone> zones =
          (jsonDecode(response.data!) as List).cast<Map<String, dynamic>>().map((json) => Zone.fromJson(json)).toList();
      state = _Result(state: ProviderState.success, data: zones);
    } catch (err) {
      if (kDebugMode) print(err);
      state = _Result(state: ProviderState.exception, data: []);
    }
  }
}

class _Result extends ProviderValue<List<Zone>> {
  _Result({required super.state, required super.data});
}
