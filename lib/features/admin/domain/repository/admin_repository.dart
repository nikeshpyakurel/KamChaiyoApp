import 'package:dartz/dartz.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/admin/domain/entity/chatbot_setting_entity.dart';
import 'package:kamchaiyo/features/admin/domain/entity/company_entity.dart';
import 'package:kamchaiyo/features/auth/domain/entity/user_entity.dart';

abstract class AdminRepository {
  Future<Either<Failure, List<UserEntity>>> getAllUsers();
  Future<Either<Failure, List<CompanyEntity>>> getAllCompanies();
  Future<Either<Failure, CompanyEntity>> toggleCompanyVerification(String companyId);
  Future<Either<Failure, ChatbotSettingEntity>> getChatbotSettings();
  Future<Either<Failure, ChatbotSettingEntity>> updateChatbotSettings(String newPrompt);
}