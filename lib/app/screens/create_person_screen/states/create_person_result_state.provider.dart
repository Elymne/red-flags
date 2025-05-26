import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/actions/persons/add_person.provider.dart';
import 'package:red_flags/app/screens/create_person_screen/form/person_form_controller.dart';
import 'package:red_flags/core/states/widget_state.dart';

final createPersonResultStateProvider = StateNotifierProvider<CreatePersonResultStateNotifier, CreatePersonResultState>((ref) {
  return CreatePersonResultStateNotifier(ref);
});

class CreatePersonResultStateNotifier extends StateNotifier<CreatePersonResultState> {
  final Ref ref;

  CreatePersonResultStateNotifier(this.ref) : super(CreatePersonResultState(status: WidgetStatus.init));

  Future<void> create(PersonFormController ctrl) async {
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
    try {} catch (e) {
      state = CreatePersonResultState(status: WidgetStatus.failure);
    }
  }

  void reset() => state = CreatePersonResultState(status: WidgetStatus.init);
}

class CreatePersonResultState extends WidgetState {
  CreatePersonResultState({required super.status});
}
