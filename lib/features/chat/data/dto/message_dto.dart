import 'package:json_annotation/json_annotation.dart';
import 'package:kamchaiyo/features/chat/domain/entity/message_entity.dart';
import 'package:kamchaiyo/features/chat/domain/entity/user_chat_entity.dart';

part 'message_dto.g.dart';

@JsonSerializable()
class MessageSenderDto {
  @JsonKey(name: '_id')
  final String id;
  final String fullName;
  final Map<String, dynamic>? profile;

  String? get avatar => profile?['avatar'] as String?;

  MessageSenderDto({required this.id, required this.fullName, this.profile});
  factory MessageSenderDto.fromJson(Map<String, dynamic> json) =>
      _$MessageSenderDtoFromJson(json);
}

@JsonSerializable()
class MessageDto {
  @JsonKey(name: '_id')
  final String id;
  final String content;
  final DateTime createdAt;
  final MessageSenderDto sender;

  @JsonKey(name: 'chat', fromJson: _chatIdFromJson)
  final String chatId;

  MessageDto({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.sender,
    required this.chatId,
  });

  factory MessageDto.fromJson(Map<String, dynamic> json) =>
      _$MessageDtoFromJson(json);

  MessageEntity toEntity() {
    return MessageEntity(
      id: id,
      content: content,
      chatId: chatId,
      createdAt: createdAt,
      sender: UserChatEntity(
        id: sender.id,
        fullName: sender.fullName,
        avatar: sender.avatar,
      ),
    );
  }
}

String _chatIdFromJson(dynamic json) {
  if (json is String) {
    return json;
  }
  if (json is Map<String, dynamic> && json.containsKey('_id')) {
    return json['_id'] as String;
  }
  return '';
}