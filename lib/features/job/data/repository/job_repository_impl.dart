import 'package:dartz/dartz.dart';
import 'package:kamchaiyo/core/error/exception.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/job/data/data_source/remote/job_remote_data_source.dart';
import 'package:kamchaiyo/features/job/domain/entity/job_entity.dart';
import 'package:kamchaiyo/features/job/domain/repository/job_repository.dart';
import 'package:kamchaiyo/features/job/domain/use_case/post_job_usecase.dart';
import 'package:kamchaiyo/features/job/domain/use_case/update_job_usecase.dart';

class JobRepositoryImpl implements JobRepository {
  final JobRemoteDataSource remoteDataSource;
  JobRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<JobEntity>>> getMyPostedJobs() async {
    try {
      final jobs = await remoteDataSource.getMyPostedJobs();
      return Right(jobs.map((dto) => dto.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, JobEntity>> postJob(PostJobParams params) async {
    try {
      final job = await remoteDataSource.postJob(params.toJson());
      return Right(job.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, JobEntity>> updateJob(UpdateJobParams params) async {
    try {
      final job =
          await remoteDataSource.updateJob(params.id, params.toJson());
      return Right(job.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteJob(String jobId) async {
    try {
      await remoteDataSource.deleteJob(jobId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  // New Method Implementation
  @override
  Future<Either<Failure, List<JobEntity>>> getJobRecommendations() async {
    try {
      final jobs = await remoteDataSource.getJobRecommendations();
      return Right(jobs.map((dto) => dto.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }


  @override
  Future<Either<Failure, List<JobEntity>>> searchJobs(
      {String? keyword, String? location}) async {
    try {
      final jobs =
          await remoteDataSource.searchJobs(keyword: keyword, location: location);
      return Right(jobs.map((dto) => dto.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, JobEntity>> getJobById(String jobId) async {
    try {
      final job = await remoteDataSource.getJobById(jobId);
      return Right(job.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}