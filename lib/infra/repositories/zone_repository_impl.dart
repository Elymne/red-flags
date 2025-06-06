import 'package:red_flags/core/result/either.dart';
import 'package:red_flags/core/result/failure.dart';
import 'package:red_flags/core/result/failure_type.dart';
import 'package:red_flags/core/result/success.dart';
import 'package:red_flags/domain/entities/zone.entity.dart';
import 'package:red_flags/domain/repositories/zone_repository.dart';
import 'package:red_flags/infra/datasources/remote_zone_datasource.dart';

class ZoneRepositoryImpl implements ZoneRepository {
  final RemoteZoneDatasource remoteZoneDatasource;

  ZoneRepositoryImpl({required this.remoteZoneDatasource});

  @override
  Future<Either<FailureType, List<Zone>>> find(String name) async {
    final result = await remoteZoneDatasource.fetchManyByName(name);
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
  Future<Either<FailureType, Zone>> findOneByID(String id) async {
    final result = await remoteZoneDatasource.fetchOneByID(id);
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
