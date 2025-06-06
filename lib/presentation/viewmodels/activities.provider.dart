import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/core/reactive/reactive_state.dart';
import 'package:red_flags/core/result/failure_type.dart';
import 'package:red_flags/di/usecases_providers.dart';
import 'package:red_flags/domain/entities/activity.entity.dart';
import 'package:red_flags/domain/usecases/search_activities.usecase.dart';

final activitiesProvider = StateNotifierProvider<ActivitiesStateNotifier, ActivitiesState>((ref) {
  return ActivitiesStateNotifier(ref.read(searchActivitiesProvider));
});

class ActivitiesStateNotifier extends StateNotifier<ActivitiesState> {
  final SearchActivities searchActivities;

  ActivitiesStateNotifier(this.searchActivities) : super(ActivitiesState(status: ReactiveStateStatus.inactive, data: []));

  Future<void> search(String name) async {
    try {
      state = ActivitiesState(status: ReactiveStateStatus.loading, data: []);
      final result = await searchActivities.perform(SearchActivitiesParams(name: name));
      result.fold(
        (failureType) {
          state = ActivitiesState(status: ReactiveStateStatus.failure, data: [], failureType: failureType);
        },
        (activities) {
          state = ActivitiesState(status: ReactiveStateStatus.success, data: activities);
        },
      );
    } catch (err) {
      state = ActivitiesState(status: ReactiveStateStatus.success, data: [], failureType: FailureType.exception);
    }
  }

  void reset() => state = ActivitiesState(status: ReactiveStateStatus.inactive, data: []);
}

class ActivitiesState extends ReactiveState<List<Activity>> {
  ActivitiesState({required super.status, required super.data, super.failureType});
}
