// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageSenderDto _$MessageSenderDtoFromJson(Map<String, dynamic> json) =>
    MessageSenderDto(
      id: json['_id'] as String,
      fullName: json['fullName'] as String,
      profile: json['profile'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$MessageSenderDtoToJson(MessageSenderDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'fullName': instance.fullName,
      'profile': instance.profile,
    };

MessageDto _$MessageDtoFromJson(Map<String, dynamic> json) => MessageDto(
      id: json['_id'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      sender: MessageSenderDto.fromJson(json['sender'] as Map<String, dynamic>),
      chatId: _chatIdFromJson(json['chat']),
    );

Map<String, dynamic> _$MessageDtoToJson(MessageDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'content': instance.content,
      'createdAt': instance.createdAt.toIso8601String(),
      'sender': instance.sender,
      'chat': instance.chatId,
    };
