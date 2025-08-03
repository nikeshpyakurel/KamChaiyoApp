import 'package:json_annotation/json_annotation.dart';
import 'package:kamchaiyo/features/my_applications/domain/entity/my_application_entity.dart';

part 'my_application_dto.g.dart';

@JsonSerializable()
class CompanyInJobDto {
  final String name;
  final String? logo;
  CompanyInJobDto({required this.name, this.logo});
  factory CompanyInJobDto.fromJson(Map<String, dynamic> json) =>
      _$CompanyInJobDtoFromJson(json);
}

@JsonSerializable()
class JobInApplicationDto {
  final String title;
  final CompanyInJobDto company;
  JobInApplicationDto({required this.title, required this.company});
  factory JobInApplicationDto.fromJson(Map<String, dynamic> json) =>
      _$JobInApplicationDtoFromJson(json);
}

@JsonSerializable()
class MyApplicationDto {
  @JsonKey(name: '_id')
  final String id;
  final String status;
  final DateTime createdAt;
  final JobInApplicationDto job;

  MyApplicationDto({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.job,
  });

  factory MyApplicationDto.fromJson(Map<String, dynamic> json) =>
      _$MyApplicationDtoFromJson(json);

  MyApplicationEntity toEntity() => MyApplicationEntity(
        id: id,
        jobTitle: job.title,
        companyName: job.company.name,
        companyLogo: job.company.logo,
        status: status,
        appliedDate: createdAt,
      );
}