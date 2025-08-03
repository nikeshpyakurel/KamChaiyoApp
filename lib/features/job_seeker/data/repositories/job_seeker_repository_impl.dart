import 'package:dartz/dartz.dart';
import 'package:kamchaiyo/core/error/exception.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/job_seeker/data/data_sources/remote/job_seeker_remote_data_source.dart';
import 'package:kamchaiyo/features/job_seeker/domain/entities/job_search_response_entity.dart';
import 'package:kamchaiyo/features/job_seeker/domain/repositories/job_seeker_repository.dart';
import 'package:kamchaiyo/features/job_seeker/domain/usecases/search_jobs_usecase.dart';
import 'package:kamchaiyo/features/job_seeker/domain/usecases/apply_for_job_usecase.dart';

class JobSeekerRepositoryImpl implements JobSeekerRepository {
  final JobSeekerRemoteDataSource remoteDataSource;
  JobSeekerRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, JobSearchResponseEntity>> searchJobs(
      SearchJobsParams params) async {
    try {
      final result = await remoteDataSource.searchJobs(params.toMap());
      return Right(JobSearchResponseEntity(
        jobs: result.jobs.map((dto) => dto.toEntity()).toList(),
        totalPages: result.totalPages,
        currentPage: result.currentPage,
      ));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> applyForJob(ApplyForJobParams params) async {
    try {
      await remoteDataSource.applyForJob(params.jobId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}