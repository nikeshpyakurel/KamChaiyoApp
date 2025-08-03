import 'package:equatable/equatable.dart';

class RecruiterStatsEntity extends Equatable {
  final int totalCompanies;
  final int totalJobs;
  final int totalApplicants;

  const RecruiterStatsEntity({
    required this.totalCompanies,
    required this.totalJobs,
    required this.totalApplicants,
  });

  @override
  List<Object?> get props => [totalCompanies, totalJobs, totalApplicants];
}