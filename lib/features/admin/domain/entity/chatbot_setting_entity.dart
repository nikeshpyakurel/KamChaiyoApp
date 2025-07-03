import 'package:equatable/equatable.dart';

class ChatbotSettingEntity extends Equatable {
  final String id;
  final String systemPrompt;

  const ChatbotSettingEntity({required this.id, required this.systemPrompt});
  
  @override
  List<Object?> get props => [id, systemPrompt];
}