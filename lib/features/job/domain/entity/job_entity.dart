import 'package:equatable/equatable.dart';

class JobEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final List<String> requirements;
  final int salary;
  final String location;
  final String jobType;
  final String experienceLevel;
  final String companyName;
  final String? companyLogo;
  final String companyId;
  final DateTime createdAt; 


  const JobEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.requirements,
    required this.salary,
    required this.location,
    required this.jobType,
    required this.experienceLevel,
    required this.companyName,
    required this.createdAt,
    this.companyLogo,
    required this.companyId,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        requirements,
        salary,
        location,
        jobType,
        experienceLevel,
        companyName,
        companyLogo,
        companyId,
        createdAt
      ];
}