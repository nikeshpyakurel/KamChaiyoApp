import 'package:dartz/dartz.dart';
import 'package:kamchaiyo/app/use_case/usecase.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/company/domain/repository/company_repository.dart';

class DeleteCompanyUseCase implements UseCase<void, String> {
  final CompanyRepository repository;
  DeleteCompanyUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String companyId) async {
    return await repository.deleteCompany(companyId);
  }
}