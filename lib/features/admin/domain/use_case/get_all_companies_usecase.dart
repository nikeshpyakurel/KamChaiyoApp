import 'package:dartz/dartz.dart';
import 'package:kamchaiyo/app/use_case/usecase.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/admin/domain/entity/company_entity.dart';
import 'package:kamchaiyo/features/admin/domain/repository/admin_repository.dart';
import 'package:kamchaiyo/features/auth/domain/use_case/check_auth_status_usecase.dart'; 


class GetAllCompaniesUseCase implements UseCase<List<CompanyEntity>, NoParams> {
  final AdminRepository repository;

  GetAllCompaniesUseCase(this.repository);

  @override
  Future<Either<Failure, List<CompanyEntity>>> call(NoParams params) async {
    return await repository.getAllCompanies();
  }
}