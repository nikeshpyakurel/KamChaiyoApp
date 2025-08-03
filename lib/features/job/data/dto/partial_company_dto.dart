import 'package:json_annotation/json_annotation.dart';

part 'partial_company_dto.g.dart';

@JsonSerializable()
class PartialCompanyDto {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String? logo;

  PartialCompanyDto({
    required this.id,
    required this.name,
    this.logo,
  });

  factory PartialCompanyDto.fromJson(Map<String, dynamic> json) =>
      _$PartialCompanyDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PartialCompanyDtoToJson(this);
}