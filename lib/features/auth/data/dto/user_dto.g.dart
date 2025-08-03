// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileDetailsDto _$ProfileDetailsDtoFromJson(Map<String, dynamic> json) =>
    ProfileDetailsDto(
      avatar: json['avatar'] as String?,
      bio: json['bio'] as String?,
      skills:
          (json['skills'] as List<dynamic>?)?.map((e) => e as String).toList(),
      resume: json['resume'] as String?,
    );

Map<String, dynamic> _$ProfileDetailsDtoToJson(ProfileDetailsDto instance) =>
    <String, dynamic>{
      'avatar': instance.avatar,
      'bio': instance.bio,
      'skills': instance.skills,
      'resume': instance.resume,
    };

UserDto _$UserDtoFromJson(Map<String, dynamic> json) => UserDto(
      id: json['_id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      phone: json['phoneNumber'] as String,
      role: json['role'] as String,
      profile: json['profile'] == null
          ? null
          : ProfileDetailsDto.fromJson(json['profile'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserDtoToJson(UserDto instance) => <String, dynamic>{
      '_id': instance.id,
      'fullName': instance.fullName,
      'email': instance.email,
      'phoneNumber': instance.phone,
      'role': instance.role,
      'profile': instance.profile,
    };
