import 'package:dartz/dartz.dart';
import 'package:kamchaiyo/app/use_case/usecase.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/admin/domain/entity/chatbot_setting_entity.dart';
import 'package:kamchaiyo/features/admin/domain/repository/admin_repository.dart';
import 'package:kamchaiyo/features/auth/domain/use_case/check_auth_status_usecase.dart';

class GetChatbotSettingsUseCase implements UseCase<ChatbotSettingEntity, NoParams> {
  final AdminRepository repository;

  GetChatbotSettingsUseCase(this.repository);

  @override
  Future<Either<Failure, ChatbotSettingEntity>> call(NoParams params) async {
    return await repository.getChatbotSettings();
  }
}