import 'package:dio/dio.dart';
import 'package:kamchaiyo/core/error/exception.dart';
import 'package:kamchaiyo/core/network/api_endpoints.dart';
import 'package:kamchaiyo/core/network/dio_client.dart';
import 'package:kamchaiyo/features/application/data/dto/application_dto.dart';

abstract class ApplicationRemoteDataSource {
  Future<List<ApplicationDto>> getJobApplicants(String jobId);
  Future<ApplicationDto> updateApplicationStatus(String applicationId, String status);
    Future<void> applyForJob(String jobId);

}

class ApplicationRemoteDataSourceImpl implements ApplicationRemoteDataSource {
  final DioClient _dioClient;
  ApplicationRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<ApplicationDto>> getJobApplicants(String jobId) async {
    try {
      final response = await _dioClient.get('${ApiEndpoints.applications}/job/$jobId/applicants');
      final List<dynamic> data = response.data['data'];
      return data.map((json) => ApplicationDto.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Failed to fetch applicants.');
    }
  }

  @override
  Future<ApplicationDto> updateApplicationStatus(String applicationId, String status) async {
    try {
      final response = await _dioClient.patch(
        '${ApiEndpoints.applications}/$applicationId/status',
        data: {'status': status},
      );
      return ApplicationDto.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Failed to update status.');
    }
  }

  @override
  Future<void> applyForJob(String jobId) async {
    try {
      await _dioClient.post('${ApiEndpoints.applyForJob}$jobId');
    } on DioException catch (e) {
      throw ServerException(
          e.response?.data['message'] ?? 'Failed to apply for job.');
    }
  }
}