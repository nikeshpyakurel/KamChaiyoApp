
import 'package:json_annotation/json_annotation.dart';
import 'package:kamchaiyo/features/auth/data/model/auth_hive_model.dart';
import 'package:kamchaiyo/features/auth/domain/entity/user_entity.dart';

part 'user_dto.g.dart';

@JsonSerializable()
class ProfileDetailsDto {
  final String? avatar;
  final String? bio;
  final List<String>? skills;
  final String? resume;

  ProfileDetailsDto({this.avatar, this.bio, this.skills, this.resume});

  factory ProfileDetailsDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileDetailsDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileDetailsDtoToJson(this);
}

@JsonSerializable()
class UserDto {
  @JsonKey(name: '_id')
  final String id;
  final String fullName;
  final String email;
  @JsonKey(name: 'phoneNumber')
  final String phone;
  final String role;
  final ProfileDetailsDto? profile;

  UserDto({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    this.profile,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);
  Map<String, dynamic> toJson() => _$UserDtoToJson(this);

  UserEntity toEntity() => UserEntity(
        id: id,
        fullName: fullName,
        email: email,
        phone: phone,
        role: role,
        profile: ProfileEntity(
          avatar: profile?.avatar,
          bio: profile?.bio,
          skills: profile?.skills,
          resumeUrl: profile?.resume,
        ),
      );

  AuthHiveModel toHiveModel() => AuthHiveModel(
        id: id,
        fullName: fullName,
        email: email,
        phone: phone,
        role: role,
        avatar: profile?.avatar,
        bio: profile?.bio,       
        skills: profile?.skills, 
      );
}