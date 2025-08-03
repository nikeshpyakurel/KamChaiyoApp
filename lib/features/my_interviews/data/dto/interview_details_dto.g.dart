// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interview_details_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentDto _$StudentDtoFromJson(Map<String, dynamic> json) => StudentDto(
      fullName: json['fullName'] as String,
    );

Map<String, dynamic> _$StudentDtoToJson(StudentDto instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
    };

CompanyDto _$CompanyDtoFromJson(Map<String, dynamic> json) => CompanyDto(
      name: json['name'] as String,
    );

Map<String, dynamic> _$CompanyDtoToJson(CompanyDto instance) =>
    <String, dynamic>{
      'name': instance.name,
    };

JobDto _$JobDtoFromJson(Map<String, dynamic> json) => JobDto(
      title: json['title'] as String,
      company: CompanyDto.fromJson(json['company'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$JobDtoToJson(JobDto instance) => <String, dynamic>{
      'title': instance.title,
      'company': instance.company,
    };

ApplicationDto _$ApplicationDtoFromJson(Map<String, dynamic> json) =>
    ApplicationDto(
      job: JobDto.fromJson(json['job'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ApplicationDtoToJson(ApplicationDto instance) =>
    <String, dynamic>{
      'job': instance.job,
    };

InterviewDetailsDto _$InterviewDetailsDtoFromJson(Map<String, dynamic> json) =>
    InterviewDetailsDto(
      id: json['_id'] as String,
      application:
          ApplicationDto.fromJson(json['application'] as Map<String, dynamic>),
      student: StudentDto.fromJson(json['student'] as Map<String, dynamic>),
      interviewType: json['interviewType'] as String,
      date: DateTime.parse(json['date'] as String),
      time: json['time'] as String,
      locationOrLink: json['locationOrLink'] as String,
    );

Map<String, dynamic> _$InterviewDetailsDtoToJson(
        InterviewDetailsDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'application': instance.application,
      'student': instance.student,
      'interviewType': instance.interviewType,
      'date': instance.date.toIso8601String(),
      'time': instance.time,
      'locationOrLink': instance.locationOrLink,
    };
