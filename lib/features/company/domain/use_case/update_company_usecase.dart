import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kamchaiyo/app/use_case/usecase.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/company/domain/entity/company_entity.dart';
import 'package:kamchaiyo/features/company/domain/repository/company_repository.dart';

class UpdateCompanyUseCase implements UseCase<CompanyEntity, UpdateCompanyParams> {
  final CompanyRepository repository;
  UpdateCompanyUseCase(this.repository);

  @override
  Future<Either<Failure, CompanyEntity>> call(UpdateCompanyParams params) async {
    return await repository.updateCompany(params);
  }
}

class UpdateCompanyParams extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String? website;
  final String? location;
  final File? logo;

  const UpdateCompanyParams({
    required this.id,
    required this.name,
    this.description,
    this.website,
    this.location,
    this.logo,
  });

  @override
  List<Object?> get props => [id, name, description, website, location, logo];
}