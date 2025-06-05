import 'package:red_flags/core/results/either.dart';
import 'package:red_flags/core/results/failure_type.enum.dart';
import 'package:red_flags/core/usecases/Params.dart';
import 'package:red_flags/core/usecases/usecase.dart';
import 'package:red_flags/domain/entities/activity.entity.dart';
import 'package:red_flags/domain/repositories/activity_repository.dart';

class GetActivityByID extends Usecase<Either<FailureType, Activity>, GetActivityByIdParams> {
  final ActivityRepository activityRepository;

  GetActivityByID({required this.activityRepository});

  @override
  Future<Either<FailureType, Activity>> perform(GetActivityByIdParams params) async {
    return await activityRepository.findOneByID(id: params.id);
  }
}

class GetActivityByIdParams extends Params {
  final String id;
  GetActivityByIdParams({required this.id});
}
