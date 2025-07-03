// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatbot_setting_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatbotSettingDto _$ChatbotSettingDtoFromJson(Map<String, dynamic> json) =>
    ChatbotSettingDto(
      id: json['_id'] as String,
      systemPrompt: json['systemPrompt'] as String,
    );

Map<String, dynamic> _$ChatbotSettingDtoToJson(ChatbotSettingDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'systemPrompt': instance.systemPrompt,
    };
