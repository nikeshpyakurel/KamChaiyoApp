import 'package:json_annotation/json_annotation.dart';
import 'package:kamchaiyo/features/recruiter_dashboard/domain/entity/recruiter_stats_entity.dart';

part 'recruiter_stats_dto.g.dart';

@JsonSerializable()
class RecruiterStatsDto {
  final int totalCompanies;
  final int totalJobs;
  final int totalApplicants;

  RecruiterStatsDto({
    required this.totalCompanies,
    required this.totalJobs,
    required this.totalApplicants,
  });

  factory RecruiterStatsDto.fromJson(Map<String, dynamic> json) =>
      _$RecruiterStatsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RecruiterStatsDtoToJson(this);

  RecruiterStatsEntity toEntity() {
    return RecruiterStatsEntity(
      totalCompanies: totalCompanies,
      totalJobs: totalJobs,
      totalApplicants: totalApplicants,
    );
  }
}