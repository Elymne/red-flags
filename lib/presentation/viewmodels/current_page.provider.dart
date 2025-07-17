import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/core/reactive/reactive_state.dart';
import 'package:red_flags/infra/datasources/datasource_failure.enum.dart';

final currentPageProvider = StateNotifierProvider<CurrentPageStateNotifier, CurrentPageState>((ref) {
  return CurrentPageStateNotifier();
});

class CurrentPageStateNotifier extends StateNotifier<CurrentPageState> {
  CurrentPageStateNotifier() : super(CurrentPageState(status: ReactiveStateStatus.inactive, data: 0));

  void setCurrentPage(int page) => state = CurrentPageState(status: ReactiveStateStatus.inactive, data: page);

  void reset() => state = CurrentPageState(status: ReactiveStateStatus.inactive, data: 0);
}

class CurrentPageState extends ReactiveState<int, DatasourceFailure> {
  CurrentPageState({required super.status, required super.data, super.failureType});
}
