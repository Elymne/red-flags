import 'package:red_flags/core/results/either.dart';
import 'package:red_flags/core/results/failure_type.enum.dart';
import 'package:red_flags/core/usecases/Params.dart';
import 'package:red_flags/core/usecases/usecase.dart';
import 'package:red_flags/domain/repositories/person_repository.dart';

class AddNewPerson extends Usecase<Either<FailureType, Null>, AddNewPersonParams> {
  final PersonRepository personRepository;

  AddNewPerson({required this.personRepository});

  @override
  Future<Either<FailureType, Null>> perform(AddNewPersonParams params) async {
    return await personRepository.addOne(
      firstname: params.firstname,
      lastname: params.lastname,
      birthDate: params.birthDate,
      activityID: params.activityID,
      companyID: params.companyID,
      zoneID: params.zoneID,
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
