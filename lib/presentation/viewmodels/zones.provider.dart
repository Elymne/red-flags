import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/core/result/failure.dart';
import 'package:red_flags/core/reactive/reactive_state.dart';
import 'package:red_flags/di/usecases_providers.dart';
import 'package:red_flags/domain/entities/zone.entity.dart';
import 'package:red_flags/domain/usecases/search_zones.usecase.dart';

final zonesStateProvider = StateNotifierProvider<ZonesStateNotifier, ZonesState>((ref) {
  return ZonesStateNotifier(ref.read(searchZonesProvider));
});

class ZonesStateNotifier extends StateNotifier<ZonesState> {
  final SearchZones searchZones;

  ZonesStateNotifier(this.searchZones) : super(ZonesState(status: ReactiveStateStatus.inactive, data: []));

  Future<void> search(String name) async {
    try {
      state = ZonesState(status: ReactiveStateStatus.loading, data: []);
      final result = await searchZones.perform(SearchZonesParams(name: name));
      result.fold(
        (failureType) {
          state = ZonesState(status: ReactiveStateStatus.failure, data: [], failureType: failureType);
        },
        (zones) {
          state = ZonesState(status: ReactiveStateStatus.success, data: zones);
        },
      );
    } catch (err) {
      state = ZonesState(status: ReactiveStateStatus.failure, data: [], failureType: FailureType.unknown);
    }
  }

  void reset() => state = ZonesState(status: ReactiveStateStatus.inactive, data: []);
}

class ZonesState extends ReactiveState<List<Zone>> {
  ZonesState({required super.status, required super.data, super.failureType});
}
