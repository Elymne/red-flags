import 'package:red_flags/core/result/either.dart';
import 'package:red_flags/core/result/failure.dart';
import 'package:red_flags/domain/entities/activity.entity.dart';

abstract class ActivityRepository {
  Future<Either<FailureType, List<Activity>>> find(String name);
  Future<Either<FailureType, Activity>> findOneByID(String id);
}
