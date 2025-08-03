import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/company/domain/entity/company_entity.dart';
import 'package:kamchaiyo/features/company/domain/use_case/get_my_companies_usecase.dart';
import 'package:kamchaiyo/features/company/domain/use_case/update_company_usecase.dart';

abstract class CompanyRepository {
  Future<Either<Failure, List<CompanyEntity>>> getMyCompanies();
  Future<Either<Failure, CompanyEntity>> createCompany(CreateCompanyParams params);
  Future<Either<Failure, CompanyEntity>> updateCompany(UpdateCompanyParams params);
  Future<Either<Failure, void>> deleteCompany(String companyId);
    Future<Either<Failure, List<CompanyEntity>>> getPublicCompanies();

}