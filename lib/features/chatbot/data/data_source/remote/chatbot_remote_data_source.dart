import 'package:dio/dio.dart';
import 'package:kamchaiyo/core/error/exception.dart';
import 'package:kamchaiyo/core/network/api_endpoints.dart';
import 'package:kamchaiyo/core/network/dio_client.dart';
import 'package:kamchaiyo/features/chatbot/data/dto/chatbot_response_dto.dart';

abstract class ChatbotRemoteDataSource {
  Future<ChatbotResponseDto> sendQuery({
    required String query,
    required List<Map<String, String>> history,
  });
}

class ChatbotRemoteDataSourceImpl implements ChatbotRemoteDataSource {
  final DioClient _dioClient;
  ChatbotRemoteDataSourceImpl(this._dioClient);

  @override
  Future<ChatbotResponseDto> sendQuery({
    required String query,
    required List<Map<String, String>> history,
  }) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.chatbotQuery,
        data: {
          'query': query,
          'history': history,
        },
      );
      // The backend nests the response object inside a 'data' field
      return ChatbotResponseDto.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException(
          e.response?.data['message'] ?? 'Failed to get response from AI.');
    }
  }
}