import 'package:red_flags/core/result/either.dart';
import 'package:red_flags/domain/entities/zone.entity.dart';
import 'package:red_flags/infra/datasources/datasource_failure.enum.dart';

abstract class ZoneRepository {
  Future<Either<DatasourceFailure, List<Zone>>> find(String name);
  Future<Either<DatasourceFailure, Zone>> findOneByID(String id);
}
