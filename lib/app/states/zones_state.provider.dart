import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/domain/usecases/zones/get_zones.provider.dart';
import 'package:red_flags/core/states/widget_state.dart';
import 'package:red_flags/domain/models/zone.model.dart';

final zonesStateProvider = StateNotifierProvider<ZonesStateNotifier, ZonesState>((ref) => ZonesStateNotifier(ref));

class ZonesStateNotifier extends StateNotifier<ZonesState> {
  final Ref ref;

  ZonesStateNotifier(this.ref) : super(ZonesState(status: WidgetStatus.init, zones: []));

  Future<void> search(String name) async {
    state = ZonesState(status: WidgetStatus.loading, zones: state.zones);
    try {
      final zones = await ref.read(getZonesProvider(GetZonesProviderParams(zoneName: name)).future);
      state = ZonesState(status: WidgetStatus.success, zones: zones);
    } catch (err) {
      state = ZonesState(status: WidgetStatus.failure, zones: state.zones);
    }
  }

  void reset() => state = ZonesState(status: WidgetStatus.init, zones: []);
}

class ZonesState extends WidgetState {
  final List<Zone> zones;
  ZonesState({required super.status, required this.zones});
}
