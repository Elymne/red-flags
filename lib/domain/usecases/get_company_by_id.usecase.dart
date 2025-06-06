import 'package:red_flags/core/result/either.dart';
import 'package:red_flags/core/usecase/params.dart';
import 'package:red_flags/core/usecase/usecase.dart';
import 'package:red_flags/domain/entities/company.entity.dart';
import 'package:red_flags/domain/repositories/company_repository.dart';
import 'package:red_flags/infra/datasources/datasource_failure.enum.dart';

class GetCompanyByID extends Usecase<Either<DatasourceFailure, Company>, GetCompanyByIDParams> {
  final CompanyRepository companyRepository;

  GetCompanyByID({required this.companyRepository});

  @override
  Future<Either<DatasourceFailure, Company>> perform(GetCompanyByIDParams params) async {
    return await companyRepository.findOneByID(params.id);
  }
}

class GetCompanyByIDParams extends Params {
  final String id;
  GetCompanyByIDParams({required this.id});
}
