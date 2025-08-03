import 'package:equatable/equatable.dart';

class CompanyEntity extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String? website;
  final String? location;
  final String? logo;
  final bool verified;

  const CompanyEntity({
    required this.id,
    required this.name,
    this.description,
    this.website,
    this.location,
    this.logo,
    required this.verified,
  });

  @override
  List<Object?> get props =>
      [id, name, description, website, location, logo, verified];
}