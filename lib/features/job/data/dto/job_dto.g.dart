// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobDto _$JobDtoFromJson(Map<String, dynamic> json) => JobDto(
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
      company:
          PartialCompanyDto.fromJson(json['company'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$JobDtoToJson(JobDto instance) => <String, dynamic>{
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
