import 'package:json_annotation/json_annotation.dart';
import 'package:kamchaiyo/features/admin/domain/entity/company_entity.dart';

part 'company_dto.g.dart';


@JsonSerializable(createFactory: false, explicitToJson: true)
class CompanyDto {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String? description;
  final String? website;
  final String? location;
  final String? logo;
  final bool verified;
  final OwnerDto owner;

  CompanyDto({
    required this.id,
    required this.name,
    this.description,
    this.website,
    this.location,
    this.logo,
    required this.verified,
    required this.owner,
  });

  
  factory CompanyDto.fromJson(Map<String, dynamic> json) {
    final ownerData = json['owner'];
    late OwnerDto parsedOwner;

    if (ownerData is Map<String, dynamic>) {
      parsedOwner = OwnerDto.fromJson(ownerData);
    } else {
      
      parsedOwner = OwnerDto(
        fullName: 'Owner (ID: ${ownerData.toString()})',
        email: 'N/A', 
      );
    }

    return CompanyDto(
      id: json['_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      website: json['website'] as String?,
      location: json['location'] as String?,
      logo: json['logo'] as String?,
      verified: json['verified'] as bool,
      owner: parsedOwner,
    );
  }

  
  Map<String, dynamic> toJson() => _$CompanyDtoToJson(this);

  CompanyEntity toEntity() {
    return CompanyEntity(
      id: id,
      name: name,
      location: location,
      logo: logo,
      verified: verified,
      ownerName: owner.fullName,
    );
  }
}

@JsonSerializable()
class OwnerDto {
  final String fullName;
  final String email;

  OwnerDto({required this.fullName, required this.email});

  factory OwnerDto.fromJson(Map<String, dynamic> json) => _$OwnerDtoFromJson(json);
  Map<String, dynamic> toJson() => _$OwnerDtoToJson(this);
}