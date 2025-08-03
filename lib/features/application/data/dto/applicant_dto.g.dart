// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'applicant_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileDto _$ProfileDtoFromJson(Map<String, dynamic> json) => ProfileDto(
      avatar: json['avatar'] as String?,
    );

Map<String, dynamic> _$ProfileDtoToJson(ProfileDto instance) =>
    <String, dynamic>{
      'avatar': instance.avatar,
    };

ApplicantDto _$ApplicantDtoFromJson(Map<String, dynamic> json) => ApplicantDto(
      id: json['_id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      profile: json['profile'] == null
          ? null
          : ProfileDto.fromJson(json['profile'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ApplicantDtoToJson(ApplicantDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'fullName': instance.fullName,
      'email': instance.email,
      'profile': instance.profile,
    };
