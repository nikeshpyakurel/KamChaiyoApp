import 'package:json_annotation/json_annotation.dart';
import 'package:kamchaiyo/features/company/domain/entity/company_entity.dart';

part 'company_dto.g.dart';

@JsonSerializable()
class CompanyDto {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String? description;
  final String? website;
  final String? location;
  final String? logo;
  final bool verified;

  CompanyDto({
    required this.id,
    required this.name,
    this.description,
    this.website,
    this.location,
    this.logo,
    required this.verified,
  });

  factory CompanyDto.fromJson(Map<String, dynamic> json) =>
      _$CompanyDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyDtoToJson(this);

  CompanyEntity toEntity() {
    return CompanyEntity(
      id: id,
      name: name,
      description: description,
      website: website,
      location: location,
      logo: logo,
      verified: verified,
    );
  }
}