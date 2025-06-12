import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/core/reactive/reactive_state.dart';
import 'package:red_flags/infra/datasources/datasource_failure.enum.dart';

final formFocusProvider = StateNotifierProvider<FormFocusStateNotifier, FormFocusState>((ref) {
  return FormFocusStateNotifier();
});

class FormFocusStateNotifier extends StateNotifier<FormFocusState> {
  FormFocusStateNotifier() : super(FormFocusState(status: ReactiveStateStatus.inactive, data: true));

  void setVisibility(bool isVisible) => state = FormFocusState(status: ReactiveStateStatus.inactive, data: isVisible);

  void reset() => state = FormFocusState(status: ReactiveStateStatus.inactive, data: true);
}

class FormFocusState extends ReactiveState<bool, DatasourceFailure> {
  FormFocusState({required super.status, required super.data, super.failureType});
}
