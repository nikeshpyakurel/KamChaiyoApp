import 'package:json_annotation/json_annotation.dart';
import 'package:kamchaiyo/features/application/data/dto/applicant_dto.dart';
import 'package:kamchaiyo/features/application/domain/entity/application_entity.dart';

part 'application_dto.g.dart';


@JsonSerializable()
class JobInApplicationDto {
  final String title;
  JobInApplicationDto({required this.title});
  factory JobInApplicationDto.fromJson(Map<String, dynamic> json) => _$JobInApplicationDtoFromJson(json);
  Map<String, dynamic> toJson() => _$JobInApplicationDtoToJson(this);
}


@JsonSerializable()
class ApplicationDto {
  @JsonKey(name: '_id')
  final String id;
  final String status;
  final ApplicantDto applicant;
  final DateTime createdAt; 
    final String job; 
  ApplicationDto({
    required this.id,
    required this.status,
    required this.applicant,
    required this.createdAt,
    required this.job,
  });

  factory ApplicationDto.fromJson(Map<String, dynamic> json) => _$ApplicationDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ApplicationDtoToJson(this);

  ApplicationEntity toEntity() => ApplicationEntity(
        id: id,
        status: status,
        applicant: applicant.toEntity(),
        jobTitle: '',
        createdAt: createdAt, 
      );
}