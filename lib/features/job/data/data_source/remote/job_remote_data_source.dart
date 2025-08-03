import 'package:dio/dio.dart';
import 'package:kamchaiyo/core/error/exception.dart';
import 'package:kamchaiyo/core/network/api_endpoints.dart';
import 'package:kamchaiyo/core/network/dio_client.dart';
import 'package:kamchaiyo/features/job/data/dto/job_dto.dart';

abstract class JobRemoteDataSource {
  Future<List<JobDto>> getMyPostedJobs();
  Future<JobDto> postJob(Map<String, dynamic> data);
  Future<JobDto> updateJob(String jobId, Map<String, dynamic> data);
  Future<void> deleteJob(String jobId);
  Future<List<JobDto>> getJobRecommendations();
    Future<List<JobDto>> searchJobs({String? keyword, String? location});
      Future<JobDto> getJobById(String jobId);


}

class JobRemoteDataSourceImpl implements JobRemoteDataSource {
  final DioClient _dioClient;
  JobRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<JobDto>> getMyPostedJobs() async {
    try {
      final response = await _dioClient.get(ApiEndpoints.jobs);
      final List<dynamic> jobList = response.data['data'];
      return jobList.map((json) => JobDto.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          e.response?.data['message'] ?? 'Failed to fetch jobs.');
    }
  }

  @override
  Future<JobDto> postJob(Map<String, dynamic> data) async {
    try {
      final response = await _dioClient.post(ApiEndpoints.jobs, data: data);
      return JobDto.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException(
          e.response?.data['message'] ?? 'Failed to post job.');
    }
  }

  @override
  Future<JobDto> updateJob(String jobId, Map<String, dynamic> data) async {
    try {
      final response =
          await _dioClient.patch('${ApiEndpoints.jobs}/$jobId', data: data);
      return JobDto.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException(
          e.response?.data['message'] ?? 'Failed to update job.');
    }
  }

  @override
  Future<void> deleteJob(String jobId) async {
    try {
      await _dioClient.delete('${ApiEndpoints.jobs}/$jobId');
    } on DioException catch (e) {
      throw ServerException(
          e.response?.data['message'] ?? 'Failed to delete job.');
    }
  }

  @override
  Future<List<JobDto>> getJobRecommendations() async {
    try {
      final response = await _dioClient.get(ApiEndpoints.getJobRecommendations);
      final List<dynamic> jobList = response.data['data'];
      return jobList.map((json) => JobDto.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          e.response?.data['message'] ?? 'Failed to fetch recommendations.');
    }
  }

  @override
  Future<List<JobDto>> searchJobs({String? keyword, String? location}) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (keyword != null && keyword.isNotEmpty) {
        queryParameters['keyword'] = keyword;
      }
      if (location != null && location.isNotEmpty) {
        queryParameters['location'] = location;
      }

      final response = await _dioClient.get(
        ApiEndpoints.publicJobs,
        queryParameters: queryParameters,
      );
      final List<dynamic> jobList = response.data['data']['jobs'];
      return jobList.map((json) => JobDto.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          e.response?.data['message'] ?? 'Failed to search jobs.');
    }
  }

  @override
  Future<JobDto> getJobById(String jobId) async {
    try {
      final response = await _dioClient.get('${ApiEndpoints.publicJobDetail}$jobId');
      return JobDto.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException(
          e.response?.data['message'] ?? 'Failed to fetch job details.');
    }
  }
}