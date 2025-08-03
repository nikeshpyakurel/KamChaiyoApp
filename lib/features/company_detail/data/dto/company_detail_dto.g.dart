// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_detail_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobInCompanyDetailDto _$JobInCompanyDetailDtoFromJson(
        Map<String, dynamic> json) =>
    JobInCompanyDetailDto(
      id: json['_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      requirements: (json['requirements'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      salary: (json['salary'] as num).toInt(),
      location: json['location'] as String,
      jobType: json['jobType'] as String,
      experienceLevel: json['experienceLevel'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      company: json['company'] as String,
    );

Map<String, dynamic> _$JobInCompanyDetailDtoToJson(
        JobInCompanyDetailDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'requirements': instance.requirements,
      'salary': instance.salary,
      'location': instance.location,
      'jobType': instance.jobType,
      'experienceLevel': instance.experienceLevel,
      'createdAt': instance.createdAt.toIso8601String(),
      'company': instance.company,
    };

CompanyDetailDto _$CompanyDetailDtoFromJson(Map<String, dynamic> json) =>
    CompanyDetailDto(
      company: CompanyDto.fromJson(json['company'] as Map<String, dynamic>),
      jobs: (json['jobs'] as List<dynamic>)
          .map((e) => JobInCompanyDetailDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CompanyDetailDtoToJson(CompanyDetailDto instance) =>
    <String, dynamic>{
      'company': instance.company,
      'jobs': instance.jobs,
    };
