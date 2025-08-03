part of 'job_detail_bloc.dart';

abstract class JobDetailEvent extends Equatable {
  const JobDetailEvent();

  @override
  List<Object> get props => [];
}

class JobDetailFetched extends JobDetailEvent {
  final String jobId;
  const JobDetailFetched(this.jobId);

  @override
  List<Object> get props => [jobId];
}

class JobApplyButtonPressed extends JobDetailEvent {}