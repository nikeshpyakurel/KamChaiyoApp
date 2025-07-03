// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
