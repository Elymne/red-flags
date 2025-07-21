import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/core/reactive/reactive_state.dart';
import 'package:red_flags/infra/datasources/datasource_failure.enum.dart';

final currentScreenProvider = StateNotifierProvider<CurrentScreenStateNotifier, CurrentScreenState>((ref) {
  return CurrentScreenStateNotifier();
});

class CurrentScreenStateNotifier extends StateNotifier<CurrentScreenState> {
  CurrentScreenStateNotifier() : super(CurrentScreenState(status: ReactiveStateStatus.inactive, data: 0));

  void updateCurrentScreen(int index) => state = CurrentScreenState(status: ReactiveStateStatus.inactive, data: index);
}

class CurrentScreenState extends ReactiveState<int, UiFailure> {
  CurrentScreenState({required super.status, required super.data, super.failureType});
}
