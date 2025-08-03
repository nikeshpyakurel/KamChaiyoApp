// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recruiter_stats_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecruiterStatsDto _$RecruiterStatsDtoFromJson(Map<String, dynamic> json) =>
    RecruiterStatsDto(
      totalCompanies: (json['totalCompanies'] as num).toInt(),
      totalJobs: (json['totalJobs'] as num).toInt(),
      totalApplicants: (json['totalApplicants'] as num).toInt(),
    );

Map<String, dynamic> _$RecruiterStatsDtoToJson(RecruiterStatsDto instance) =>
    <String, dynamic>{
      'totalCompanies': instance.totalCompanies,
      'totalJobs': instance.totalJobs,
      'totalApplicants': instance.totalApplicants,
    };
