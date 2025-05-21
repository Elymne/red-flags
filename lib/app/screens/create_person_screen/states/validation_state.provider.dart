import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/core/states/widget_state.dart';

final validationStateProvider = StateNotifierProvider<ValidationStateNotifier, ValidationState>((ref) {
  return ValidationStateNotifier(ref);
});

class ValidationStateNotifier extends StateNotifier<ValidationState> {
  final Ref ref;

  ValidationStateNotifier(this.ref) : super(ValidationState(status: WidgetStatus.init, isValidate: false));

  Future<void> check({
    required String firstname,
    required String lastname,
    required DateTime birthDate,
    required String zoneName,
    required String companyName,
    required String activityName,
  }) async {
    state = ValidationState(status: WidgetStatus.loading, isValidate: false);
    try {} catch (e) {
      state = ValidationState(status: WidgetStatus.failure, isValidate: state.isValidate);
    }
  }
}

class ValidationState extends WidgetState {
  final bool isValidate;

  ValidationState({required super.status, required this.isValidate});
}
