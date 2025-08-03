import 'package:dartz/dartz.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/job/domain/entity/job_entity.dart';
import 'package:kamchaiyo/features/job/domain/use_case/post_job_usecase.dart';
import 'package:kamchaiyo/features/job/domain/use_case/update_job_usecase.dart';

abstract class JobRepository {
  Future<Either<Failure, List<JobEntity>>> getMyPostedJobs();
  Future<Either<Failure, JobEntity>> postJob(PostJobParams params);
  Future<Either<Failure, JobEntity>> updateJob(UpdateJobParams params);
  Future<Either<Failure, void>> deleteJob(String jobId);
  Future<Either<Failure, List<JobEntity>>> getJobRecommendations(); // New Method
  Future<Either<Failure, List<JobEntity>>> searchJobs(
      {String? keyword, String? location}); 
  Future<Either<Failure, JobEntity>> getJobById(String jobId); // New

}