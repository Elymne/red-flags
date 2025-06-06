import 'package:red_flags/core/result/either.dart';
import 'package:red_flags/core/usecase/params.dart';
import 'package:red_flags/core/usecase/usecase.dart';
import 'package:red_flags/domain/entities/company.entity.dart';
import 'package:red_flags/domain/repositories/company_repository.dart';
import 'package:red_flags/infra/datasources/datasource_failure.enum.dart';

class SearchCompanies extends Usecase<Either<DatasourceFailure, List<Company>>, SearchCompaniesParams> {
  final CompanyRepository companyRepository;

  SearchCompanies({required this.companyRepository});

  @override
  Future<Either<DatasourceFailure, List<Company>>> perform(SearchCompaniesParams params) async {
    return await companyRepository.find(params.name);
  }
}

class SearchCompaniesParams extends Params {
  final String name;
  SearchCompaniesParams({required this.name});
}
