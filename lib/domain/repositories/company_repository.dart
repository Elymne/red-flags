import 'package:red_flags/core/result/either.dart';
import 'package:red_flags/domain/entities/company.entity.dart';
import 'package:red_flags/infra/datasources/datasource_failure.enum.dart';

abstract class CompanyRepository {
  Future<Either<DatasourceFailure, List<Company>>> find(String name);
  Future<Either<DatasourceFailure, Company>> findOneByID(String id);
}
