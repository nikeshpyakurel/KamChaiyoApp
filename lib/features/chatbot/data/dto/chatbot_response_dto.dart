import 'package:json_annotation/json_annotation.dart';

part 'chatbot_response_dto.g.dart';

@JsonSerializable()
class ChatbotResponseDto {
  final String response;

  ChatbotResponseDto({required this.response});

  factory ChatbotResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ChatbotResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ChatbotResponseDtoToJson(this);
}