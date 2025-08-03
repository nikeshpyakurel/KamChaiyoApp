import 'package:dartz/dartz.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/job_seeker/domain/entities/job_search_response_entity.dart';
import 'package:kamchaiyo/features/job_seeker/domain/usecases/apply_for_job_usecase.dart';
import 'package:kamchaiyo/features/job_seeker/domain/usecases/search_jobs_usecase.dart';

abstract class JobSeekerRepository {
  Future<Either<Failure, JobSearchResponseEntity>> searchJobs(
      SearchJobsParams params);
  Future<Either<Failure, void>> applyForJob(ApplyForJobParams params);
}