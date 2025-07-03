import 'package:dartz/dartz.dart';
import 'package:kamchaiyo/core/error/exception.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/admin/data/data_source/remote/admin_remote_data_source.dart';
import 'package:kamchaiyo/features/admin/domain/entity/chatbot_setting_entity.dart';
import 'package:kamchaiyo/features/admin/domain/entity/company_entity.dart';
import 'package:kamchaiyo/features/admin/domain/repository/admin_repository.dart';
import 'package:kamchaiyo/features/auth/domain/entity/user_entity.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource remoteDataSource;
  AdminRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<UserEntity>>> getAllUsers() async {
    try {
      final userDtos = await remoteDataSource.getAllUsers();
      return Right(userDtos.map((dto) => dto.toEntity()).toList());
    } on ServerException catch(e) { return Left(ServerFailure(message: e.message)); }
  }

  @override
  Future<Either<Failure, List<CompanyEntity>>> getAllCompanies() async {
    try {
      final companyDtos = await remoteDataSource.getAllCompanies();
      return Right(companyDtos.map((dto) => dto.toEntity()).toList());
    } on ServerException catch(e) { return Left(ServerFailure(message: e.message)); }
  }

  @override
  Future<Either<Failure, CompanyEntity>> toggleCompanyVerification(String companyId) async {
    try {
      final companyDto = await remoteDataSource.toggleCompanyVerification(companyId);
      return Right(companyDto.toEntity());
    } on ServerException catch(e) { return Left(ServerFailure(message: e.message)); }
  }

  @override
  Future<Either<Failure, ChatbotSettingEntity>> getChatbotSettings() async {
    try {
      final dto = await remoteDataSource.getChatbotSettings();
      return Right(dto.toEntity());
    } on ServerException catch(e) { return Left(ServerFailure(message: e.message)); }
  }

  @override
  Future<Either<Failure, ChatbotSettingEntity>> updateChatbotSettings(String newPrompt) async {
    try {
      final dto = await remoteDataSource.updateChatbotSettings(newPrompt);
      return Right(dto.toEntity());
    } on ServerException catch(e) { return Left(ServerFailure(message: e.message)); }
  }
}