import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/actions/persons/add_person.provider.dart';
import 'package:red_flags/app/screens/create_person_screen/form_controller/person_form_controller.dart';
import 'package:red_flags/core/states/widget_state.dart';

final createPersonStateProvider = StateNotifierProvider<CreatePersonStateNotifier, CreatePersonState>((ref) {
  return CreatePersonStateNotifier(ref);
});

class CreatePersonStateNotifier extends StateNotifier<CreatePersonState> {
  final Ref ref;

  CreatePersonStateNotifier(this.ref) : super(CreatePersonState(status: WidgetStatus.init));

  Future<void> create(PersonFormController ctrl) async {
    state = CreatePersonState(status: WidgetStatus.loading);
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
    state = CreatePersonState(status: WidgetStatus.success);
    try {} catch (e) {
      state = CreatePersonState(status: WidgetStatus.failure);
    }
  }

  void reset() => state = CreatePersonState(status: WidgetStatus.init);
}

class CreatePersonState extends WidgetState {
  CreatePersonState({required super.status});
}
