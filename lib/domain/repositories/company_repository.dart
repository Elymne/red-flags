import 'package:red_flags/core/result/either.dart';
import 'package:red_flags/core/result/failure_type.dart';
import 'package:red_flags/domain/entities/company.entity.dart';

abstract class CompanyRepository {
  Future<Either<FailureType, List<Company>>> find(String name);
  Future<Either<FailureType, Company>> findOneByID(String id);
}
