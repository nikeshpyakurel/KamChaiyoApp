import 'package:json_annotation/json_annotation.dart';
import 'package:kamchaiyo/features/chat/data/dto/message_dto.dart';
import 'package:kamchaiyo/features/chat/domain/entity/chat_entity.dart';
import 'package:kamchaiyo/features/chat/domain/entity/user_chat_entity.dart';

part 'chat_dto.g.dart';

@JsonSerializable()
class ChatUserDto {
  @JsonKey(name: '_id')
  final String id;
  final String fullName;
  
  ChatUserDto({required this.id, required this.fullName});
  factory ChatUserDto.fromJson(Map<String, dynamic> json) => _$ChatUserDtoFromJson(json);
}

@JsonSerializable()
class ChatDto {
  @JsonKey(name: '_id')
  final String id;
  final List<ChatUserDto> users;
  final MessageDto? latestMessage;

  ChatDto({required this.id, required this.users, this.latestMessage});

  factory ChatDto.fromJson(Map<String, dynamic> json) => _$ChatDtoFromJson(json);
  
  ChatEntity toEntity(String currentUserId) {
    final otherUser = users.firstWhere(
      (user) => user.id != currentUserId,
      orElse: () => users.first,
    );
    return ChatEntity(
      id: id,
      otherUser: UserChatEntity(id: otherUser.id, fullName: otherUser.fullName, avatar: null),
      latestMessage: latestMessage?.toEntity(),
    );
  }
}