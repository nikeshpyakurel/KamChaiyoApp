import 'package:equatable/equatable.dart';

class InterviewDetailsEntity extends Equatable {
  final String id;
  final String applicantName;
  final String jobTitle;
  final String companyName;
  final String interviewType;
  final DateTime date;
  final String time;
  final String locationOrLink;

  const InterviewDetailsEntity({
    required this.id,
    required this.applicantName,
    required this.jobTitle,
    required this.companyName,
    required this.interviewType,
    required this.date,
    required this.time,
    required this.locationOrLink,
  });

  @override
  List<Object> get props => [
        id,
        applicantName,
        jobTitle,
        companyName,
        interviewType,
        date,
        time,
        locationOrLink
      ];
}