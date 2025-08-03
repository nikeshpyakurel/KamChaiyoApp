
import 'package:equatable/equatable.dart';

abstract class ApplicationEvent extends Equatable{
  const ApplicationEvent();
  @override
  List<Object> get props => [];
}

class ApplicantsFetched extends ApplicationEvent {
  final String jobId;
  const ApplicantsFetched(this.jobId);
  @override
  List<Object> get props => [jobId];
}

class ApplicationStatusUpdated extends ApplicationEvent {
  final String applicationId;
  final String status;
  const ApplicationStatusUpdated(this.applicationId, this.status);
  @override
  List<Object> get props => [applicationId, status];
}