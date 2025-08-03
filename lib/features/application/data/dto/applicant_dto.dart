import 'package:json_annotation/json_annotation.dart';
import 'package:kamchaiyo/features/application/domain/entity/applicant_entity.dart';

part 'applicant_dto.g.dart';

@JsonSerializable()
class ProfileDto {
  final String? avatar;
  ProfileDto({this.avatar});

  factory ProfileDto.fromJson(Map<String, dynamic> json) => _$ProfileDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileDtoToJson(this);
}

@JsonSerializable()
class ApplicantDto {
  @JsonKey(name: '_id')
  final String id;
  final String fullName;
  final String email;
  final ProfileDto? profile;

  ApplicantDto({required this.id, required this.fullName, required this.email, this.profile});

  factory ApplicantDto.fromJson(Map<String, dynamic> json) => _$ApplicantDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ApplicantDtoToJson(this);

  ApplicantEntity toEntity() => ApplicantEntity(
        id: id,
        fullName: fullName,
        email: email,
        avatar: profile?.avatar,
      );
}