part of 'job_feed_bloc.dart';

abstract class JobFeedEvent extends Equatable {
  const JobFeedEvent();

  @override
  List<Object> get props => [];
}

class JobFeedFetched extends JobFeedEvent {}