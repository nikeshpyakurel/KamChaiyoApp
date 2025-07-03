import 'package:dartz/dartz.dart';
import 'package:kamchaiyo/app/use_case/usecase.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/admin/domain/entity/chatbot_setting_entity.dart';
import 'package:kamchaiyo/features/admin/domain/repository/admin_repository.dart';


class UpdateChatbotSettingsUseCase implements UseCase<ChatbotSettingEntity, String> {
  final AdminRepository repository;

  UpdateChatbotSettingsUseCase(this.repository);

  @override
  Future<Either<Failure, ChatbotSettingEntity>> call(String newPrompt) async {
    return await repository.updateChatbotSettings(newPrompt);
  }
}