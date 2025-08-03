// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobInApplicationDto _$JobInApplicationDtoFromJson(Map<String, dynamic> json) =>
    JobInApplicationDto(
      title: json['title'] as String,
    );

Map<String, dynamic> _$JobInApplicationDtoToJson(
        JobInApplicationDto instance) =>
    <String, dynamic>{
      'title': instance.title,
    };

ApplicationDto _$ApplicationDtoFromJson(Map<String, dynamic> json) =>
    ApplicationDto(
      id: json['_id'] as String,
      status: json['status'] as String,
      applicant:
          ApplicantDto.fromJson(json['applicant'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      job: json['job'] as String,
    );

Map<String, dynamic> _$ApplicationDtoToJson(ApplicationDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'status': instance.status,
      'applicant': instance.applicant,
      'createdAt': instance.createdAt.toIso8601String(),
      'job': instance.job,
    };
