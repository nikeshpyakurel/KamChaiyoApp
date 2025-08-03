import 'package:dartz/dartz.dart';
import 'package:kamchaiyo/core/error/exception.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/company_detail/data/data_source/remote/company_detail_remote_data_source.dart';
import 'package:kamchaiyo/features/company_detail/domain/entity/company_detail_entity.dart';
import 'package:kamchaiyo/features/company_detail/domain/repository/company_detail_repository.dart';

class CompanyDetailRepositoryImpl implements CompanyDetailRepository {
  final CompanyDetailRemoteDataSource remoteDataSource;
  CompanyDetailRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, CompanyDetailEntity>> getCompanyDetail(String companyId) async {
    try {
      final result = await remoteDataSource.getCompanyDetail(companyId);
      return Right(result.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}