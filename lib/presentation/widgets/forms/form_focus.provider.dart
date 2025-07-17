import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/core/reactive/reactive_state.dart';
import 'package:red_flags/infra/datasources/datasource_failure.enum.dart';

final formFocusProvider = StateNotifierProvider<FormFocusStateNotifier, FormFocusState>((ref) {
  return FormFocusStateNotifier();
});

class FormFocusStateNotifier extends StateNotifier<FormFocusState> {
  FormFocusStateNotifier() : super(FormFocusState(status: ReactiveStateStatus.inactive, data: false));

  void hasFocus(bool value) => state = FormFocusState(status: ReactiveStateStatus.inactive, data: value);

  void reset() => state = FormFocusState(status: ReactiveStateStatus.inactive, data: false);
}

class FormFocusState extends ReactiveState<bool, DatasourceFailure> {
  FormFocusState({required super.status, required super.data, super.failureType});
}
