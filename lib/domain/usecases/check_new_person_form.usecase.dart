import 'package:red_flags/core/result/either.dart';
import 'package:red_flags/core/result/failure.dart';
import 'package:red_flags/core/result/failure_type.dart';
import 'package:red_flags/core/result/success.dart';
import 'package:red_flags/core/usecase/params.dart';
import 'package:red_flags/core/usecase/usecase.dart';
import 'package:red_flags/domain/repositories/activity_repository.dart';
import 'package:red_flags/domain/repositories/company_repository.dart';
import 'package:red_flags/domain/repositories/person_repository.dart';
import 'package:red_flags/domain/repositories/zone_repository.dart';

class CheckNewPersonForm extends Usecase<Either<FailureType, bool>, CheckNewPersonFormParams> {
  final ActivityRepository activityRepository;
  final ZoneRepository zoneRepository;
  final CompanyRepository companyRepository;
  final PersonRepository personRepository;

  CheckNewPersonForm({
    required this.activityRepository,
    required this.zoneRepository,
    required this.companyRepository,
    required this.personRepository,
  });

  @override
  Future<Either<FailureType, bool>> perform(CheckNewPersonFormParams params) async {
    if (params.firstname == null ||
        params.firstname!.isEmpty ||
        params.lastname == null ||
        params.lastname!.isEmpty ||
        params.birthDate == null ||
        params.activityID == null ||
        params.zoneID == null ||
        params.companyID == null) {
      return Success(false);
    }

    final results = await Future.wait([
      activityRepository.findOneByID(params.activityID!),
      zoneRepository.findOneByID(params.zoneID!),
      companyRepository.findOneByID(params.companyID!),
    ]);

    for (var result in results) {
      if (result.isFailure()) {
        return Failure((result as Failure).value);
      }
    }

    // * Fetch persons that correspond to inputs.
    final personsResult = await personRepository.find(
      activityID: params.activityID,
      companyID: params.companyID,
      birthDate: params.birthDate,
      firstname: params.firstname,
      lastname: params.lastname,
      zoneID: params.zoneID,
    );

    final isOk = personsResult.fold<int>((failureType) => 0, (persons) => persons.isNotEmpty ? 1 : 2);

    if (isOk == 0) {
      return Failure((personsResult as Failure).value);
    }

    if (isOk == 1) {
      return Success(false);
    }

    return Success(true);
  }
}

class CheckNewPersonFormParams extends Params {
  final String? firstname;
  final String? lastname;
  final DateTime? birthDate;
  final String? activityID;
  final String? zoneID;
  final String? companyID;

  CheckNewPersonFormParams({this.firstname, this.lastname, this.birthDate, this.activityID, this.zoneID, this.companyID});
}
