import 'package:dartz/dartz.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/company_detail/domain/entity/company_detail_entity.dart';

abstract class CompanyDetailRepository {
  Future<Either<Failure, CompanyDetailEntity>> getCompanyDetail(String companyId);
}