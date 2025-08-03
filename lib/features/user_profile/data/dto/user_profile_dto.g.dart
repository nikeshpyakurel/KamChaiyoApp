// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileDetailsDto _$ProfileDetailsDtoFromJson(Map<String, dynamic> json) =>
    ProfileDetailsDto(
      bio: json['bio'] as String?,
      skills:
          (json['skills'] as List<dynamic>?)?.map((e) => e as String).toList(),
      resume: json['resume'] as String?,
      resumeOriginalName: json['resumeOriginalName'] as String?,
      avatar: json['avatar'] as String?,
    );

Map<String, dynamic> _$ProfileDetailsDtoToJson(ProfileDetailsDto instance) =>
    <String, dynamic>{
      'bio': instance.bio,
      'skills': instance.skills,
      'resume': instance.resume,
      'resumeOriginalName': instance.resumeOriginalName,
      'avatar': instance.avatar,
    };

UserProfileDto _$UserProfileDtoFromJson(Map<String, dynamic> json) =>
    UserProfileDto(
      id: json['_id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      profile: json['profile'] == null
          ? null
          : ProfileDetailsDto.fromJson(json['profile'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserProfileDtoToJson(UserProfileDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'fullName': instance.fullName,
      'email': instance.email,
      'profile': instance.profile,
    };
