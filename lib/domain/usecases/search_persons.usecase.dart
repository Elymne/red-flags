import 'package:red_flags/core/results/either.dart';
import 'package:red_flags/core/results/failure_type.enum.dart';
import 'package:red_flags/core/usecases/Params.dart';
import 'package:red_flags/core/usecases/usecase.dart';
import 'package:red_flags/domain/entities/person.entity.dart';
import 'package:red_flags/domain/repositories/person_repository.dart';

class SearchPersons extends Usecase<Either<FailureType, List<Person>>, SearchPersonsParams> {
  final PersonRepository personRepository;

  SearchPersons({required this.personRepository});

  @override
  Future<Either<FailureType, List<Person>>> perform(SearchPersonsParams params) async {
    return await personRepository.find(
      firstname: params.firstname,
      lastname: params.lastname,
      birthDate: params.birthDate,
      activityID: params.activityID,
      companyID: params.companyID,
      zoneID: params.zoneID,
    );
  }
}

class SearchPersonsParams extends Params {
  final String? firstname;
  final String? lastname;
  final DateTime? birthDate;
  final String? activityID;
  final String? zoneID;
  final String? companyID;

  SearchPersonsParams({this.firstname, this.lastname, this.birthDate, this.activityID, this.zoneID, this.companyID});
}
