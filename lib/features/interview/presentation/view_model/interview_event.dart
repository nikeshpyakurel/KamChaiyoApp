
import 'package:equatable/equatable.dart';
import 'package:kamchaiyo/features/interview/domain/use_case/schedule_interview_usecase.dart';

abstract class InterviewEvent extends Equatable {
  const InterviewEvent();
  @override
  List<Object> get props => [];
}

class InterviewScheduled extends InterviewEvent {
  final ScheduleInterviewParams params;
  const InterviewScheduled(this.params);
  @override
  List<Object> get props => [params];
}