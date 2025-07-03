import 'package:dartz/dartz.dart';
import 'package:kamchaiyo/app/use_case/usecase.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/admin/domain/entity/company_entity.dart';
import 'package:kamchaiyo/features/admin/domain/repository/admin_repository.dart';

class ToggleCompanyVerificationUseCase implements UseCase<CompanyEntity, String> {
  final AdminRepository repository;

  ToggleCompanyVerificationUseCase(this.repository);

  @override
  Future<Either<Failure, CompanyEntity>> call(String companyId) async {
    return await repository.toggleCompanyVerification(companyId);
  }
}