import 'package:red_flags/core/results/either.dart';
import 'package:red_flags/core/results/failure.dart';
import 'package:red_flags/domain/entities/company.entity.dart';

abstract class CompanyRepository {
  Future<Either<FailureType, List<Company>>> find(String name);
  Future<Either<FailureType, Company>> findOneByID(String id);
}
