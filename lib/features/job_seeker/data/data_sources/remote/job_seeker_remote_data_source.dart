import 'package:dio/dio.dart';
import 'package:kamchaiyo/core/error/exception.dart';
import 'package:kamchaiyo/core/network/api_endpoints.dart';
import 'package:kamchaiyo/core/network/dio_client.dart';
import 'package:kamchaiyo/features/job_seeker/data/dto/job_search_response_dto.dart';

abstract class JobSeekerRemoteDataSource {
  Future<JobSearchResponseDto> searchJobs(Map<String, dynamic> params);
  Future<void> applyForJob(String jobId);
}

class JobSeekerRemoteDataSourceImpl implements JobSeekerRemoteDataSource {
  final DioClient _dioClient;
  JobSeekerRemoteDataSourceImpl(this._dioClient);

  @override
  Future<JobSearchResponseDto> searchJobs(Map<String, dynamic> params) async {
    try {
      final response = await _dioClient.get(
        '${ApiEndpoints.jobs}/public',
        queryParameters: params,
      );
      return JobSearchResponseDto.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException(
          e.response?.data['message'] ?? 'Failed to search jobs.');
    }
  }

  @override
  Future<void> applyForJob(String jobId) async {
    try {
      await _dioClient.post('${ApiEndpoints.applications}/apply/$jobId');
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Failed to apply for job.');
    }
  }
}