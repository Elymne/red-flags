import 'package:red_flags/core/results/either.dart';
import 'package:red_flags/core/results/failure_type.enum.dart';
import 'package:red_flags/core/usecases/Params.dart';
import 'package:red_flags/core/usecases/usecase.dart';
import 'package:red_flags/domain/entities/company.entity.dart';
import 'package:red_flags/domain/repositories/company_repository.dart';

class GetCompanyByID extends Usecase<Either<FailureType, Company>, GetCompanyByIDParams> {
  final CompanyRepository companyRepository;

  GetCompanyByID({required this.companyRepository});

  @override
  Future<Either<FailureType, Company>> perform(GetCompanyByIDParams params) async {
    return await companyRepository.findOneByID(id: params.id);
  }
}

class GetCompanyByIDParams extends Params {
  final String id;
  GetCompanyByIDParams({required this.id});
}
