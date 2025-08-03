import 'package:dio/dio.dart';
import 'package:kamchaiyo/core/error/exception.dart';
import 'package:kamchaiyo/core/network/api_endpoints.dart';
import 'package:kamchaiyo/core/network/dio_client.dart';
import 'package:kamchaiyo/features/recruiter_dashboard/data/dto/recruiter_stats_dto.dart';

abstract class RecruiterRemoteDataSource {
  Future<RecruiterStatsDto> getRecruiterStats();
}

class RecruiterRemoteDataSourceImpl implements RecruiterRemoteDataSource {
  final DioClient _dioClient;

  RecruiterRemoteDataSourceImpl(this._dioClient);

  @override
  Future<RecruiterStatsDto> getRecruiterStats() async {
    try {
      final response = await _dioClient.get(ApiEndpoints.recruiterStats);
      return RecruiterStatsDto.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException(
          e.response?.data['message'] ?? 'Failed to fetch recruiter stats.');
    }
  }
}