import 'package:red_flags/core/result/either.dart';
import 'package:red_flags/core/result/failure.dart';
import 'package:red_flags/core/usecases/Params.dart';
import 'package:red_flags/core/usecase/usecase.dart';
import 'package:red_flags/domain/entities/company.entity.dart';
import 'package:red_flags/domain/repositories/company_repository.dart';

class SearchCompanies extends Usecase<Either<FailureType, List<Company>>, SearchCompaniesParams> {
  final CompanyRepository companyRepository;

  SearchCompanies({required this.companyRepository});

  @override
  Future<Either<FailureType, List<Company>>> perform(SearchCompaniesParams params) async {
    return await companyRepository.find(params.name);
  }
}

class SearchCompaniesParams extends Params {
  final String name;
  SearchCompaniesParams({required this.name});
}
