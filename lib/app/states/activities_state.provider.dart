import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/core/states/widget_state.dart';
import 'package:red_flags/domain/models/activity.model.dart';
import 'package:red_flags/domain/usecases/activities/get_activities.provider.dart';

final activitiesStateProvider = StateNotifierProvider<ActivitiesStateNotifier, ActivitiesState>((ref) => ActivitiesStateNotifier(ref));

class ActivitiesStateNotifier extends StateNotifier<ActivitiesState> {
  final Ref ref;

  ActivitiesStateNotifier(this.ref) : super(ActivitiesState(status: WidgetStatus.init, activities: []));

  Future<void> search(String name) async {
    state = ActivitiesState(status: WidgetStatus.loading, activities: state.activities);
    try {
      final activities = await ref.read(getActivitiesProvider(GetActivitiesProviderParams(activityName: name)).future);
      if (activities.isEmpty) {
        state = ActivitiesState(status: WidgetStatus.failure, activities: state.activities);
      }
      state = ActivitiesState(status: WidgetStatus.success, activities: activities);
    } catch (err) {
      state = ActivitiesState(status: WidgetStatus.failure, activities: state.activities);
    }
  }

  void reset() => state = ActivitiesState(status: WidgetStatus.init, activities: []);
}

class ActivitiesState extends WidgetState {
  final List<Activity> activities;
  ActivitiesState({required super.status, required this.activities});
}
