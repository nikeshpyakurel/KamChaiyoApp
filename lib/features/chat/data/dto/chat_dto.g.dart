// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatUserDto _$ChatUserDtoFromJson(Map<String, dynamic> json) => ChatUserDto(
      id: json['_id'] as String,
      fullName: json['fullName'] as String,
    );

Map<String, dynamic> _$ChatUserDtoToJson(ChatUserDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'fullName': instance.fullName,
    };

ChatDto _$ChatDtoFromJson(Map<String, dynamic> json) => ChatDto(
      id: json['_id'] as String,
      users: (json['users'] as List<dynamic>)
          .map((e) => ChatUserDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      latestMessage: json['latestMessage'] == null
          ? null
          : MessageDto.fromJson(json['latestMessage'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChatDtoToJson(ChatDto instance) => <String, dynamic>{
      '_id': instance.id,
      'users': instance.users,
      'latestMessage': instance.latestMessage,
    };
