// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partial_company_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartialCompanyDto _$PartialCompanyDtoFromJson(Map<String, dynamic> json) =>
    PartialCompanyDto(
      id: json['_id'] as String,
      name: json['name'] as String,
      logo: json['logo'] as String?,
    );

Map<String, dynamic> _$PartialCompanyDtoToJson(PartialCompanyDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'logo': instance.logo,
    };
