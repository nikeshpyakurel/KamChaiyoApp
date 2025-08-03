import 'package:json_annotation/json_annotation.dart';
import 'package:kamchaiyo/features/company/data/dto/company_dto.dart';
import 'package:kamchaiyo/features/company_detail/domain/entity/company_detail_entity.dart';
import 'package:kamchaiyo/features/job/domain/entity/job_entity.dart';

part 'company_detail_dto.g.dart';

@JsonSerializable()
class JobInCompanyDetailDto {
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
  final String company; 
  JobInCompanyDetailDto({
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

  factory JobInCompanyDetailDto.fromJson(Map<String, dynamic> json) =>
      _$JobInCompanyDetailDtoFromJson(json);
}

@JsonSerializable()
class CompanyDetailDto {
  final CompanyDto company;
  final List<JobInCompanyDetailDto> jobs;

  CompanyDetailDto({required this.company, required this.jobs});

  factory CompanyDetailDto.fromJson(Map<String, dynamic> json) {
    return CompanyDetailDto(
      company: CompanyDto.fromJson(json['company'] as Map<String, dynamic>),
      jobs: (json['jobs'] as List<dynamic>)
          .map((e) => JobInCompanyDetailDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  CompanyDetailEntity toEntity() {
    
    final jobEntities = jobs.map((jobDto) {
      return JobEntity(
        id: jobDto.id,
        title: jobDto.title,
        description: jobDto.description,
        requirements: jobDto.requirements,
        salary: jobDto.salary,
        location: jobDto.location,
        jobType: jobDto.jobType,
        experienceLevel: jobDto.experienceLevel,
        createdAt: jobDto.createdAt,
        companyId: company.id,
        companyName: company.name,
        companyLogo: company.logo,
      );
    }).toList();

    return CompanyDetailEntity(
      company: company.toEntity(),
      jobs: jobEntities,
    );
  }
}