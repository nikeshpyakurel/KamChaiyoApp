import 'package:json_annotation/json_annotation.dart';
import 'package:kamchaiyo/features/admin/domain/entity/chatbot_setting_entity.dart';
part 'chatbot_setting_dto.g.dart';

@JsonSerializable()
class ChatbotSettingDto {
  @JsonKey(name: '_id')
  final String id;
  final String systemPrompt;

  ChatbotSettingDto({required this.id, required this.systemPrompt});

  factory ChatbotSettingDto.fromJson(Map<String, dynamic> json) => _$ChatbotSettingDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ChatbotSettingDtoToJson(this);

  ChatbotSettingEntity toEntity() {
    return ChatbotSettingEntity(id: id, systemPrompt: systemPrompt);
  }
}