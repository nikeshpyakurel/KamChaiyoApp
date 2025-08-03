import 'package:equatable/equatable.dart';

class MyApplicationEntity extends Equatable {
  final String id;
  final String jobTitle;
  final String companyName;
  final String? companyLogo;
  final String status;
  final DateTime appliedDate;

  const MyApplicationEntity({
    required this.id,
    required this.jobTitle,
    required this.companyName,
    this.companyLogo,
    required this.status,
    required this.appliedDate,
  });

  @override
  List<Object?> get props =>
      [id, jobTitle, companyName, companyLogo, status, appliedDate];
}