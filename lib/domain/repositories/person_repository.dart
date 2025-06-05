import 'package:red_flags/core/results/either.dart';
import 'package:red_flags/core/results/failure.dart';
import 'package:red_flags/domain/entities/person.entity.dart';

abstract class PersonRepository {
  Future<Either<FailureType, List<Person>>> find({
    String? firstname,
    String? lastname,
    DateTime? birthDate,
    String? activityID,
    String? zoneID,
    String? companyID,
  });

  Future<Either<FailureType, Person>> findOneByID(String id);

  Future<Either<FailureType, Null>> addOne(
    String firstname,
    String lastname,
    DateTime birthDate,
    String activityID,
    String zoneID,
    String companyID,
  );
}
