import 'package:equatable/equatable.dart';
import 'package:kamchaiyo/features/application/domain/entity/applicant_entity.dart';

class ApplicationEntity extends Equatable {
  final String id;
  final String status;
  final ApplicantEntity applicant;
  final String jobTitle;
  final DateTime createdAt;

  const ApplicationEntity({
    required this.id,
    required this.status,
    required this.applicant,
    required this.jobTitle,
    required this.createdAt,
  });

  @override
  List<Object> get props => [id, status, applicant, jobTitle, createdAt];
}