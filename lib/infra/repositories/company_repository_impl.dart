import 'package:red_flags/core/result/either.dart';
import 'package:red_flags/core/result/failure.dart';
import 'package:red_flags/core/result/success.dart';
import 'package:red_flags/domain/entities/company.entity.dart';
import 'package:red_flags/domain/repositories/company_repository.dart';
import 'package:red_flags/infra/datasources/datasource_failure.enum.dart';
import 'package:red_flags/infra/datasources/remote_company_datasource.dart';

class CompanyRepositoryImpl implements CompanyRepository {
  final RemoteCompanyDatasource remoteCompanyDatasource;

  CompanyRepositoryImpl({required this.remoteCompanyDatasource});

  @override
  Future<Either<DatasourceFailure, List<Company>>> find(String name) async {
    final result = await remoteCompanyDatasource.fetchManyByName(name);
    return result.fold(
      (type) {
        return Failure(type);
      },
      (value) {
        return Success(value.map((elem) => elem.toEntity()).toList());
      },
    );
  }

  @override
  Future<Either<DatasourceFailure, Company>> findOneByID(String id) async {
    final result = await remoteCompanyDatasource.fetchOneByID(id);
    return result.fold(
      (type) {
        return Failure(type);
      },
      (value) {
        return Success(value.toEntity());
      },
    );
  }
}
