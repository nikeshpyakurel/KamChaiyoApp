import 'package:dartz/dartz.dart';
import 'package:kamchaiyo/app/use_case/usecase.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/company_detail/domain/entity/company_detail_entity.dart';
import 'package:kamchaiyo/features/company_detail/domain/repository/company_detail_repository.dart';

class GetCompanyDetailUseCase implements UseCase<CompanyDetailEntity, String> {
  final CompanyDetailRepository repository;
  GetCompanyDetailUseCase(this.repository);

  @override
  Future<Either<Failure, CompanyDetailEntity>> call(String companyId) {
    return repository.getCompanyDetail(companyId);
  }
}