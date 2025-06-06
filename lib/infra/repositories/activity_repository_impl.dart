import 'package:red_flags/core/result/either.dart';
import 'package:red_flags/core/result/failure.dart';
import 'package:red_flags/core/result/success.dart';
import 'package:red_flags/domain/entities/activity.entity.dart';
import 'package:red_flags/domain/repositories/activity_repository.dart';
import 'package:red_flags/infra/datasources/remote_activity_datasource.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  final RemoteActivityDatasource remoteActivityDatasource;

  ActivityRepositoryImpl({required this.remoteActivityDatasource});

  @override
  Future<Either<FailureType, List<Activity>>> find(String name) async {
    final result = await remoteActivityDatasource.fetchManyByName(name);
    return result.fold(
      (type) {
        return Failure(type);
      },
      (value) {
        return Success(value.map((elem) => elem.toEntity()).toList());
      },
    );
  }

  @override
  Future<Either<FailureType, Activity>> findOneByID(String id) async {
    final result = await remoteActivityDatasource.fetchOneByID(id);
    return result.fold(
      (type) {
        return Failure(type);
      },
      (value) {
        return Success(value.toEntity());
      },
    );
  }
}
