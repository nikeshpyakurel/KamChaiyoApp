import 'package:dartz/dartz.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/interview/domain/entity/interview_entity.dart';
import 'package:kamchaiyo/features/interview/domain/use_case/schedule_interview_usecase.dart';

abstract class InterviewRepository {
  Future<Either<Failure, InterviewEntity>> scheduleInterview(
      ScheduleInterviewParams params);
}