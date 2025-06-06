import 'package:red_flags/core/result/either.dart';
import 'package:red_flags/core/usecase/params.dart';
import 'package:red_flags/core/usecase/usecase.dart';
import 'package:red_flags/domain/entities/activity.entity.dart';
import 'package:red_flags/domain/repositories/activity_repository.dart';
import 'package:red_flags/infra/datasources/datasource_failure.enum.dart';

class SearchActivities extends Usecase<Either<DatasourceFailure, List<Activity>>, SearchActivitiesParams> {
  final ActivityRepository activityRepository;

  SearchActivities({required this.activityRepository});

  @override
  Future<Either<DatasourceFailure, List<Activity>>> perform(SearchActivitiesParams params) async {
    return await activityRepository.find(params.name);
  }
}

class SearchActivitiesParams extends Params {
  final String name;
  SearchActivitiesParams({required this.name});
}
