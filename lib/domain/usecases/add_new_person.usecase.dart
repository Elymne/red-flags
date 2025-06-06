import 'package:red_flags/core/result/either.dart';
import 'package:red_flags/core/result/failure.dart';
import 'package:red_flags/core/usecases/Params.dart';
import 'package:red_flags/core/usecase/usecase.dart';
import 'package:red_flags/domain/repositories/person_repository.dart';

class AddNewPerson extends Usecase<Either<FailureType, Null>, AddNewPersonParams> {
  final PersonRepository personRepository;

  AddNewPerson({required this.personRepository});

  @override
  Future<Either<FailureType, Null>> perform(AddNewPersonParams params) async {
    return await personRepository.addOne(
      params.firstname,
      params.lastname,
      params.birthDate,
      params.activityID,
      params.zoneID,
      params.companyID,
    );
  }
}

class AddNewPersonParams extends Params {
  final String firstname;
  final String lastname;
  final DateTime birthDate;
  final String activityID;
  final String zoneID;
  final String companyID;
  AddNewPersonParams({
    required this.firstname,
    required this.lastname,
    required this.birthDate,
    required this.activityID,
    required this.zoneID,
    required this.companyID,
  });
}
