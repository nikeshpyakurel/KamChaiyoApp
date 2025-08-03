import 'package:equatable/equatable.dart';
import 'package:kamchaiyo/features/job/domain/entity/job_entity.dart';

class JobSearchResponseEntity extends Equatable {
  final List<JobEntity> jobs;
  final int totalPages;
  final int currentPage;

  const JobSearchResponseEntity({
    required this.jobs,
    required this.totalPages,
    required this.currentPage,
  });

  @override
  List<Object> get props => [jobs, totalPages, currentPage];
}