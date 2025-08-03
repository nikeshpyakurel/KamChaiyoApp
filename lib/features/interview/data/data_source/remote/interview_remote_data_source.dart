import 'package:dio/dio.dart';
import 'package:kamchaiyo/core/error/exception.dart';
import 'package:kamchaiyo/core/network/api_endpoints.dart';
import 'package:kamchaiyo/core/network/dio_client.dart';
import 'package:kamchaiyo/features/interview/data/dto/interview_dto.dart';
import 'package:kamchaiyo/features/interview/domain/use_case/schedule_interview_usecase.dart';

abstract class InterviewRemoteDataSource {
  Future<InterviewDto> scheduleInterview(ScheduleInterviewParams params);
}

class InterviewRemoteDataSourceImpl implements InterviewRemoteDataSource {
  final DioClient _dioClient;
  InterviewRemoteDataSourceImpl(this._dioClient);

  @override
  Future<InterviewDto> scheduleInterview(ScheduleInterviewParams params) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.scheduleInterview,
        data: params.toJson(),
      );
      return InterviewDto.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Failed to schedule interview.');
    }
  }
}