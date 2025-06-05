import 'package:red_flags/core/results/either.dart';
import 'package:red_flags/core/results/failure.dart';
import 'package:red_flags/core/usecases/Params.dart';
import 'package:red_flags/core/usecases/usecase.dart';
import 'package:red_flags/domain/entities/activity.entity.dart';
import 'package:red_flags/domain/repositories/activity_repository.dart';

class SearchActivities extends Usecase<Either<FailureType, List<Activity>>, SearchActivitiesParams> {
  final ActivityRepository activityRepository;

  SearchActivities({required this.activityRepository});

  @override
  Future<Either<FailureType, List<Activity>>> perform(SearchActivitiesParams params) async {
    return await activityRepository.find(params.name);
  }
}

class SearchActivitiesParams extends Params {
  final String name;
  SearchActivitiesParams({required this.name});
}
