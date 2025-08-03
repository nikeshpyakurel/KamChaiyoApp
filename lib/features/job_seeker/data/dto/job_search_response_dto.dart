import 'package:json_annotation/json_annotation.dart';
import 'package:kamchaiyo/features/job/data/dto/job_dto.dart';

part 'job_search_response_dto.g.dart';

@JsonSerializable()
class JobSearchResponseDto {
  final List<JobDto> jobs;
  final int totalPages;
  final int currentPage;

  JobSearchResponseDto({
    required this.jobs,
    required this.totalPages,
    required this.currentPage,
  });

  factory JobSearchResponseDto.fromJson(Map<String, dynamic> json) =>
      _$JobSearchResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$JobSearchResponseDtoToJson(this);
}