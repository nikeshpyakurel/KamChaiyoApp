import 'package:dio/dio.dart';
import 'package:kamchaiyo/core/error/exception.dart';
import 'package:kamchaiyo/core/network/api_endpoints.dart';
import 'package:kamchaiyo/core/network/dio_client.dart';
import 'package:kamchaiyo/features/my_interviews/data/dto/interview_details_dto.dart';

abstract class MyInterviewsRemoteDataSource {
  Future<List<InterviewDetailsDto>> getMyInterviews();
}

class MyInterviewsRemoteDataSourceImpl implements MyInterviewsRemoteDataSource {
  final DioClient _dioClient;
  MyInterviewsRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<InterviewDetailsDto>> getMyInterviews() async {
    try {
      final response = await _dioClient.get(ApiEndpoints.myInterviews);
      final List<dynamic> data = response.data['data'];
      return data.map((json) => InterviewDetailsDto.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Failed to fetch interviews.');
    }
  }
}