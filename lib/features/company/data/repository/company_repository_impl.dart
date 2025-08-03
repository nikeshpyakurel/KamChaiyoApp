import 'package:kamchaiyo/features/company/domain/use_case/get_my_companies_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:kamchaiyo/core/error/exception.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/company/data/data_source/remote/company_remote_data_source.dart';
import 'package:kamchaiyo/features/company/domain/entity/company_entity.dart';
import 'package:kamchaiyo/features/company/domain/repository/company_repository.dart';
import 'package:kamchaiyo/features/company/domain/use_case/update_company_usecase.dart';

class CompanyRepositoryImpl implements CompanyRepository {
  final CompanyRemoteDataSource remoteDataSource;
  CompanyRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<CompanyEntity>>> getMyCompanies() async {
    try {
      final companyDtos = await remoteDataSource.getMyCompanies();
      return Right(companyDtos.map((dto) => dto.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, CompanyEntity>> createCompany(
      CreateCompanyParams params) async {
    try {
      final companyDto = await remoteDataSource.createCompany(
        name: params.name,
        description: params.description,
        website: params.website,
        location: params.location,
        logo: params.logo,
      );
      return Right(companyDto.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
@override
  Future<Either<Failure, CompanyEntity>> updateCompany(UpdateCompanyParams params) async {
    try {
      final companyDto = await remoteDataSource.updateCompany(
        companyId: params.id,
        name: params.name,
        description: params.description,
        website: params.website,
        location: params.location,
        logo: params.logo,
      );
      return Right(companyDto.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCompany(String companyId) async {
    try {
      await remoteDataSource.deleteCompany(companyId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
  @override
  Future<Either<Failure, List<CompanyEntity>>> getPublicCompanies() async {
    try {
      final companyDtos = await remoteDataSource.getPublicCompanies();
      return Right(companyDtos.map((dto) => dto.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
  
}