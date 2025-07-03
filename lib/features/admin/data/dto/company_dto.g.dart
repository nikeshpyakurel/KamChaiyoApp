// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyDto _$CompanyDtoFromJson(Map<String, dynamic> json) => CompanyDto(
      id: json['_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      website: json['website'] as String?,
      location: json['location'] as String?,
      logo: json['logo'] as String?,
      verified: json['verified'] as bool,
      owner: OwnerDto.fromJson(json['owner'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CompanyDtoToJson(CompanyDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'website': instance.website,
      'location': instance.location,
      'logo': instance.logo,
      'verified': instance.verified,
      'owner': instance.owner.toJson(),
    };

OwnerDto _$OwnerDtoFromJson(Map<String, dynamic> json) => OwnerDto(
      fullName: json['fullName'] as String,
      email: json['email'] as String,
    );

Map<String, dynamic> _$OwnerDtoToJson(OwnerDto instance) => <String, dynamic>{
      'fullName': instance.fullName,
      'email': instance.email,
    };
