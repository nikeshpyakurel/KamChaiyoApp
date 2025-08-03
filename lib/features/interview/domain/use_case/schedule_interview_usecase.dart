import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kamchaiyo/app/use_case/usecase.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/interview/domain/entity/interview_entity.dart';
import 'package:kamchaiyo/features/interview/domain/repository/interview_repository.dart';

class ScheduleInterviewUseCase
    implements UseCase<InterviewEntity, ScheduleInterviewParams> {
  final InterviewRepository repository;
  ScheduleInterviewUseCase(this.repository);

  @override
  Future<Either<Failure, InterviewEntity>> call(ScheduleInterviewParams params) {
    return repository.scheduleInterview(params);
  }
}

class ScheduleInterviewParams extends Equatable {
  final String applicationId;
  final String interviewType;
  final DateTime date;
  final String time;
  final String locationOrLink;

  const ScheduleInterviewParams({
    required this.applicationId,
    required this.interviewType,
    required this.date,
    required this.time,
    required this.locationOrLink,
  });

  Map<String, dynamic> toJson() => {
        'applicationId': applicationId,
        'interviewType': interviewType,
        'date': date.toIso8601String(),
        'time': time,
        'locationOrLink': locationOrLink,
      };

  @override
  List<Object> get props =>
      [applicationId, interviewType, date, time, locationOrLink];
}