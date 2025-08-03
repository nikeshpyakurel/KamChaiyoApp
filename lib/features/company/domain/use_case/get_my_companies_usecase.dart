import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kamchaiyo/app/use_case/usecase.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/company/domain/entity/company_entity.dart';
import 'package:kamchaiyo/features/company/domain/repository/company_repository.dart';

class CreateCompanyUseCase implements UseCase<CompanyEntity, CreateCompanyParams> {
  final CompanyRepository repository;
  CreateCompanyUseCase(this.repository);

  @override
  Future<Either<Failure, CompanyEntity>> call(CreateCompanyParams params) async {
    return await repository.createCompany(params);
  }
}

class CreateCompanyParams extends Equatable {
  final String name;
  final String? description;
  final String? website;
  final String? location;
  final File? logo;

  const CreateCompanyParams({
    required this.name,
    this.description,
    this.website,
    this.location,
    this.logo,
  });

  @override
  List<Object?> get props => [name, description, website, location, logo];
}