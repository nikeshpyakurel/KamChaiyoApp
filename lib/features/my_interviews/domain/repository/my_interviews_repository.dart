import 'package:dartz/dartz.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/my_interviews/domain/entity/interview_details_entity.dart';

abstract class MyInterviewsRepository {
  Future<Either<Failure, List<InterviewDetailsEntity>>> getMyInterviews();
}