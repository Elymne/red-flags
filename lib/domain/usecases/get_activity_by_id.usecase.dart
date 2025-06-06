import 'package:red_flags/core/result/either.dart';
import 'package:red_flags/core/usecase/params.dart';
import 'package:red_flags/core/usecase/usecase.dart';
import 'package:red_flags/domain/entities/activity.entity.dart';
import 'package:red_flags/domain/repositories/activity_repository.dart';
import 'package:red_flags/infra/datasources/datasource_failure.enum.dart';

class GetActivityByID extends Usecase<Either<DatasourceFailure, Activity>, GetActivityByIdParams> {
  final ActivityRepository activityRepository;

  GetActivityByID({required this.activityRepository});

  @override
  Future<Either<DatasourceFailure, Activity>> perform(GetActivityByIdParams params) async {
    return await activityRepository.findOneByID(params.id);
  }
}

class GetActivityByIdParams extends Params {
  final String id;
  GetActivityByIdParams({required this.id});
}
