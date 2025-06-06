import 'package:red_flags/core/result/either.dart';
import 'package:red_flags/domain/entities/activity.entity.dart';
import 'package:red_flags/infra/datasources/datasource_failure.enum.dart';

abstract class ActivityRepository {
  Future<Either<DatasourceFailure, List<Activity>>> find(String name);
  Future<Either<DatasourceFailure, Activity>> findOneByID(String id);
}
