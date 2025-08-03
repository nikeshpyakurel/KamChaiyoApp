import 'package:json_annotation/json_annotation.dart';
import 'package:kamchaiyo/features/user_profile/domain/entity/user_profile_entity.dart';

part 'user_profile_dto.g.dart';

@JsonSerializable()
class ProfileDetailsDto {
  final String? bio;
  final List<String>? skills;
  final String? resume;
  final String? resumeOriginalName;
  final String? avatar;

  ProfileDetailsDto({
    this.bio,
    this.skills,
    this.resume,
    this.resumeOriginalName,
    this.avatar,
  });

  factory ProfileDetailsDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileDetailsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileDetailsDtoToJson(this);
}

@JsonSerializable()
class UserProfileDto {
  @JsonKey(name: '_id')
  final String id;
  final String fullName;
  final String email;
  final ProfileDetailsDto? profile;

  UserProfileDto({
    required this.id,
    required this.fullName,
    required this.email,
    this.profile,
  });

  factory UserProfileDto.fromJson(Map<String, dynamic> json) =>
      _$UserProfileDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileDtoToJson(this);

  UserProfileEntity toEntity() {
    return UserProfileEntity(
      id: id,
      fullName: fullName,
      email: email,
      bio: profile?.bio,
      skills: profile?.skills ?? [],
      resumeUrl: profile?.resume,
      resumeOriginalName: profile?.resumeOriginalName,
      avatarUrl: profile?.avatar,
    );
  }
}