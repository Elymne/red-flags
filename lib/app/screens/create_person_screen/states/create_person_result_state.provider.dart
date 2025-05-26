import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/actions/persons/add_person.provider.dart';
import 'package:red_flags/app/screens/create_person_screen/form/person_form_state.provider.dart';
import 'package:red_flags/core/exceptions/bad_user_input_exception.dart';
import 'package:red_flags/core/states/widget_state.dart';

final createPersonResultStateProvider = StateNotifierProvider<CreatePersonResultStateNotifier, CreatePersonResultState>((ref) {
  return CreatePersonResultStateNotifier(ref);
});

class CreatePersonResultStateNotifier extends StateNotifier<CreatePersonResultState> {
  final Ref ref;

  CreatePersonResultStateNotifier(this.ref) : super(CreatePersonResultState(status: WidgetStatus.init));

  Future<void> create(PersonFormState ctrl) async {
    try {
      state = CreatePersonResultState(status: WidgetStatus.loading);
      await ref.read(
        addPersonProvider(
          AddPersonProviderParams(
            firstname: ctrl.firstname,
            lastname: ctrl.lastname,
            birthDate: ctrl.birthDate!,
            zoneID: ctrl.zone!.id,
            companyID: ctrl.company?.id,
            activityID: ctrl.activity?.id,
          ),
        ).future,
      );
      state = CreatePersonResultState(status: WidgetStatus.success);
    } on BadUserInputException catch (e) {
      state = CreatePersonResultState(status: WidgetStatus.failure, errorIndex: CreatePersonResultState.userInputError);
    } catch (e) {
      state = CreatePersonResultState(status: WidgetStatus.failure, errorIndex: CreatePersonResultState.userInputError);
    }
  }

  void reset() => state = CreatePersonResultState(status: WidgetStatus.init);
}

class CreatePersonResultState extends WidgetState {
  static final int networkError = 1;
  static final int userInputError = 2;
  final int? errorIndex;

  CreatePersonResultState({required super.status, this.errorIndex});
}
