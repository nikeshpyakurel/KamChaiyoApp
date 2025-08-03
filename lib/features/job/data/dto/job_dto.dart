import 'package:json_annotation/json_annotation.dart';
import 'package:kamchaiyo/features/job/data/dto/partial_company_dto.dart';
import 'package:kamchaiyo/features/job/domain/entity/job_entity.dart';

part 'job_dto.g.dart';

@JsonSerializable()
class JobDto {
  @JsonKey(name: '_id')
  final String id;
  final String title;
  final String description;
  final List<String> requirements;
  final int salary;
  final String location;
  final String jobType;
  final String experienceLevel;
    final DateTime createdAt; 

  final PartialCompanyDto company;

  JobDto({
    required this.id,
    required this.title,
    required this.description,
    required this.requirements,
    required this.salary,
    required this.location,
    required this.jobType,
    required this.experienceLevel,
        required this.createdAt,

    required this.company,
  });

  factory JobDto.fromJson(Map<String, dynamic> json) => _$JobDtoFromJson(json);

  Map<String, dynamic> toJson() => _$JobDtoToJson(this);

  JobEntity toEntity() {
    return JobEntity(
      id: id,
      title: title,
      description: description,
      requirements: requirements,
      salary: salary,
      location: location,
      jobType: jobType,
      experienceLevel: experienceLevel,
      companyName: company.name,
      companyLogo: company.logo,
      companyId: company.id,
      createdAt: createdAt,

    );
  }
}