import 'package:dartz/dartz.dart';
import 'package:kamchaiyo/app/use_case/usecase.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/auth/domain/use_case/check_auth_status_usecase.dart';
import 'package:kamchaiyo/features/company/domain/entity/company_entity.dart';
import 'package:kamchaiyo/features/company/domain/repository/company_repository.dart';

class GetMyCompaniesUseCase implements UseCase<List<CompanyEntity>, NoParams> {
  final CompanyRepository repository;
  GetMyCompaniesUseCase(this.repository);

  @override
  Future<Either<Failure, List<CompanyEntity>>> call(NoParams params) async {
    return await repository.getMyCompanies();
  }
}