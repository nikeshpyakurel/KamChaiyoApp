import 'package:equatable/equatable.dart';

class CompanyEntity extends Equatable {
  final String id;
  final String name;
  final String? location;
  final String? logo;
  final bool verified;
  final String ownerName;

  const CompanyEntity({
    required this.id,
    required this.name,
    this.location,
    this.logo,
    required this.verified,
    required this.ownerName,
  });

  @override
  List<Object?> get props => [id, name, location, logo, verified, ownerName];
}