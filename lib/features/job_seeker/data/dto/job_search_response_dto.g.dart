// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_search_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobSearchResponseDto _$JobSearchResponseDtoFromJson(
        Map<String, dynamic> json) =>
    JobSearchResponseDto(
      jobs: (json['jobs'] as List<dynamic>)
          .map((e) => JobDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPages: (json['totalPages'] as num).toInt(),
      currentPage: (json['currentPage'] as num).toInt(),
    );

Map<String, dynamic> _$JobSearchResponseDtoToJson(
        JobSearchResponseDto instance) =>
    <String, dynamic>{
      'jobs': instance.jobs,
      'totalPages': instance.totalPages,
      'currentPage': instance.currentPage,
    };
