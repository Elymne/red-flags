import 'package:red_flags/core/results/either.dart';
import 'package:red_flags/core/results/failure_type.enum.dart';
import 'package:red_flags/core/usecases/Params.dart';
import 'package:red_flags/core/usecases/usecase.dart';
import 'package:red_flags/domain/entities/person.entity.dart';
import 'package:red_flags/domain/repositories/person_repository.dart';

class GetPersonByID extends Usecase<Either<FailureType, Person>, GetPersonByIDParams> {
  final PersonRepository zoneRepository;

  GetPersonByID({required this.zoneRepository});

  @override
  Future<Either<FailureType, Person>> perform(GetPersonByIDParams params) async {
    return await zoneRepository.findOneByID(id: params.id);
  }
}

class GetPersonByIDParams extends Params {
  final String id;
  GetPersonByIDParams({required this.id});
}
