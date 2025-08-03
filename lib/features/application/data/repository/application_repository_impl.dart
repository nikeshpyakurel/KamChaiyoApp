import 'package:dartz/dartz.dart';
import 'package:kamchaiyo/core/error/exception.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/application/data/data_source/remote/application_remote_data_source.dart';
import 'package:kamchaiyo/features/application/domain/entity/application_entity.dart';
import 'package:kamchaiyo/features/application/domain/repository/application_repository.dart';

class ApplicationRepositoryImpl implements ApplicationRepository {
  final ApplicationRemoteDataSource remoteDataSource;
  ApplicationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ApplicationEntity>>> getJobApplicants(String jobId) async {
    try {
      final result = await remoteDataSource.getJobApplicants(jobId);
      return Right(result.map((dto) => dto.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, ApplicationEntity>> updateApplicationStatus(
      String applicationId, String status) async {
    try {
      final result = await remoteDataSource.updateApplicationStatus(applicationId, status);
      return Right(result.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
  @override
  Future<Either<Failure, void>> applyForJob(String jobId) async {
    try {
      await remoteDataSource.applyForJob(jobId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}