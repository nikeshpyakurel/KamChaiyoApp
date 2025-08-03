import 'package:dio/dio.dart';
import 'package:kamchaiyo/core/error/exception.dart';
import 'package:kamchaiyo/core/network/api_endpoints.dart';
import 'package:kamchaiyo/core/network/dio_client.dart';
import 'package:kamchaiyo/features/chat/data/dto/chat_dto.dart';
import 'package:kamchaiyo/features/chat/data/dto/message_dto.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatDto>> getMyChats();
  Future<List<MessageDto>> getMessages(String chatId);
  Future<MessageDto> sendMessage(String chatId, String content);

}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final DioClient _dioClient;
  ChatRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<ChatDto>> getMyChats() async {
    try {
      final response = await _dioClient.get(ApiEndpoints.chats);
      final List<dynamic> data = response.data['data'];
      return data.map((json) => ChatDto.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Failed to fetch chats.');
    }
  }

  @override
  Future<List<MessageDto>> getMessages(String chatId) async {
    try {
      final response = await _dioClient.get('${ApiEndpoints.chatMessages}/$chatId');
      final List<dynamic> data = response.data['data'];
      return data.map((json) => MessageDto.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Failed to fetch messages.');
    }
  }

  @override
  Future<MessageDto> sendMessage(String chatId, String content) async {
    try {
      final response = await _dioClient.post(ApiEndpoints.chatMessages, data: {
        'chatId': chatId,
        'content': content,
      });
      return MessageDto.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Failed to send message.');
    }
  }
}