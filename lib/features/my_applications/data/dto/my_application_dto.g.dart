// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_application_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyInJobDto _$CompanyInJobDtoFromJson(Map<String, dynamic> json) =>
    CompanyInJobDto(
      name: json['name'] as String,
      logo: json['logo'] as String?,
    );

Map<String, dynamic> _$CompanyInJobDtoToJson(CompanyInJobDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'logo': instance.logo,
    };

JobInApplicationDto _$JobInApplicationDtoFromJson(Map<String, dynamic> json) =>
    JobInApplicationDto(
      title: json['title'] as String,
      company:
          CompanyInJobDto.fromJson(json['company'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$JobInApplicationDtoToJson(
        JobInApplicationDto instance) =>
    <String, dynamic>{
      'title': instance.title,
      'company': instance.company,
    };

MyApplicationDto _$MyApplicationDtoFromJson(Map<String, dynamic> json) =>
    MyApplicationDto(
      id: json['_id'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      job: JobInApplicationDto.fromJson(json['job'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MyApplicationDtoToJson(MyApplicationDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'job': instance.job,
    };
