import 'package:red_flags/core/result/either.dart';
import 'package:red_flags/core/result/failure.dart';
import 'package:red_flags/core/result/success.dart';
import 'package:red_flags/domain/entities/person.entity.dart';
import 'package:red_flags/domain/repositories/person_repository.dart';
import 'package:red_flags/infra/datasources/datasource_failure.enum.dart';
import 'package:red_flags/infra/datasources/remote_person_datasource.dart';

class PersonRepositoryImpl implements PersonRepository {
  final RemotePersonDatasource remotePersonDatasource;

  PersonRepositoryImpl({required this.remotePersonDatasource});

  @override
  Future<Either<DatasourceFailure, Null>> addOne(
    String firstname,
    String lastname,
    DateTime birthDate,
    String activityID,
    String zoneID,
    String companyID,
  ) async {
    final result = await remotePersonDatasource.addOne(
      firstname: firstname,
      lastname: lastname,
      birthDate: birthDate,
      zoneID: zoneID,
      activityID: activityID,
      companyID: companyID,
    );
    return result.fold(
      (type) {
        return Failure(type);
      },
      (value) {
        return Success(null);
      },
    );
  }

  @override
  Future<Either<DatasourceFailure, List<Person>>> find({
    String? firstname,
    String? lastname,
    DateTime? birthDate,
    String? activityID,
    String? zoneID,
    String? companyID,
  }) async {
    final result = await remotePersonDatasource.fetchMany(
      firstname: firstname,
      lastname: lastname,
      birthDate: birthDate,
      activityID: activityID,
      zoneID: zoneID,
      companyID: companyID,
    );
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
  Future<Either<DatasourceFailure, Person>> findOneByID(String id) async {
    final result = await remotePersonDatasource.fetchOnebyID(id);
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
