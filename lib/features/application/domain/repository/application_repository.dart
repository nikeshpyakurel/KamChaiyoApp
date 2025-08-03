import 'package:dartz/dartz.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/application/domain/entity/application_entity.dart';

abstract class ApplicationRepository {
  Future<Either<Failure, List<ApplicationEntity>>> getJobApplicants(String jobId);
  Future<Either<Failure, ApplicationEntity>> updateApplicationStatus(
      String applicationId, String status);
        Future<Either<Failure, void>> applyForJob(String jobId);

}