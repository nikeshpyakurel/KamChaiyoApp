import 'package:json_annotation/json_annotation.dart';
import 'package:kamchaiyo/features/my_interviews/domain/entity/interview_details_entity.dart';

part 'interview_details_dto.g.dart';

@JsonSerializable()
class StudentDto {
  final String fullName;
  StudentDto({required this.fullName});
  factory StudentDto.fromJson(Map<String, dynamic> json) => _$StudentDtoFromJson(json);
  Map<String, dynamic> toJson() => _$StudentDtoToJson(this);
}

@JsonSerializable()
class CompanyDto {
  final String name;
  CompanyDto({required this.name});
  factory CompanyDto.fromJson(Map<String, dynamic> json) => _$CompanyDtoFromJson(json);
  Map<String, dynamic> toJson() => _$CompanyDtoToJson(this);
}

@JsonSerializable()
class JobDto {
  final String title;
  final CompanyDto company;
  JobDto({required this.title, required this.company});
  factory JobDto.fromJson(Map<String, dynamic> json) => _$JobDtoFromJson(json);
  Map<String, dynamic> toJson() => _$JobDtoToJson(this);
}

@JsonSerializable()
class ApplicationDto {
  final JobDto job;
  ApplicationDto({required this.job});
  factory ApplicationDto.fromJson(Map<String, dynamic> json) => _$ApplicationDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ApplicationDtoToJson(this);
}

@JsonSerializable()
class InterviewDetailsDto {
  @JsonKey(name: '_id')
  final String id;
  final ApplicationDto application;
  final StudentDto student;
  final String interviewType;
  final DateTime date;
  final String time;
  final String locationOrLink;

  InterviewDetailsDto({
    required this.id,
    required this.application,
    required this.student,
    required this.interviewType,
    required this.date,
    required this.time,
    required this.locationOrLink,
  });

  factory InterviewDetailsDto.fromJson(Map<String, dynamic> json) =>
      _$InterviewDetailsDtoFromJson(json);
  Map<String, dynamic> toJson() => _$InterviewDetailsDtoToJson(this);

  InterviewDetailsEntity toEntity() {
    return InterviewDetailsEntity(
      id: id,
      applicantName: student.fullName,
      jobTitle: application.job.title,
      companyName: application.job.company.name,
      interviewType: interviewType,
      date: date,
      time: time,
      locationOrLink: locationOrLink,
    );
  }
}