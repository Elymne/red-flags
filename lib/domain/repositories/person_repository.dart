import 'package:red_flags/core/result/either.dart';
import 'package:red_flags/domain/entities/person.entity.dart';
import 'package:red_flags/infra/datasources/datasource_failure.enum.dart';

abstract class PersonRepository {
  Future<Either<DatasourceFailure, List<Person>>> find({
    String? firstname,
    String? lastname,
    DateTime? birthDate,
    String? activityID,
    String? zoneID,
    String? companyID,
  });

  Future<Either<DatasourceFailure, Person>> findOneByID(String id);

  Future<Either<DatasourceFailure, Null>> addOne(
    String firstname,
    String lastname,
    DateTime birthDate,
    String activityID,
    String zoneID,
    String companyID,
  );
}
