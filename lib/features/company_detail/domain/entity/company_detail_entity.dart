import 'package:equatable/equatable.dart';
import 'package:kamchaiyo/features/company/domain/entity/company_entity.dart';
import 'package:kamchaiyo/features/job/domain/entity/job_entity.dart';

class CompanyDetailEntity extends Equatable {
  final CompanyEntity company;
  final List<JobEntity> jobs;

  const CompanyDetailEntity({required this.company, required this.jobs});

  @override
  List<Object?> get props => [company, jobs];
}