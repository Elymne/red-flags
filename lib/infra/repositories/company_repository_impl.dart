import 'package:red_flags/core/results/either.dart';
import 'package:red_flags/core/results/failure.dart';
import 'package:red_flags/core/results/success.dart';
import 'package:red_flags/domain/entities/company.entity.dart';
import 'package:red_flags/domain/repositories/company_repository.dart';
import 'package:red_flags/infra/datasources/remote_company_datasource.dart';

class CompanyRepositoryImpl implements CompanyRepository {
  final RemoteCompanyDatasource remoteCompanyDatasource;

  CompanyRepositoryImpl({required this.remoteCompanyDatasource});

  @override
  Future<Either<FailureType, List<Company>>> find(String name) async {
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
  Future<Either<FailureType, Company>> findOneByID(String id) async {
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
