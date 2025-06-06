import 'package:red_flags/core/result/either.dart';
import 'package:red_flags/core/usecase/params.dart';
import 'package:red_flags/core/usecase/usecase.dart';
import 'package:red_flags/domain/entities/person.entity.dart';
import 'package:red_flags/domain/repositories/person_repository.dart';
import 'package:red_flags/infra/datasources/datasource_failure.enum.dart';

class GetPersonByID extends Usecase<Either<DatasourceFailure, Person>, GetPersonByIDParams> {
  final PersonRepository personRepository;

  GetPersonByID({required this.personRepository});

  @override
  Future<Either<DatasourceFailure, Person>> perform(GetPersonByIDParams params) async {
    return await personRepository.findOneByID(params.id);
  }
}

class GetPersonByIDParams extends Params {
  final String id;
  GetPersonByIDParams({required this.id});
}
