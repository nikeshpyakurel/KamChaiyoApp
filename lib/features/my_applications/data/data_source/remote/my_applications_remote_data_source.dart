import 'package:dio/dio.dart';
import 'package:kamchaiyo/core/error/exception.dart';
import 'package:kamchaiyo/core/network/api_endpoints.dart';
import 'package:kamchaiyo/core/network/dio_client.dart';
import 'package:kamchaiyo/features/my_applications/data/dto/my_application_dto.dart';

abstract class MyApplicationsRemoteDataSource {
  Future<List<MyApplicationDto>> getMyApplications();
}

class MyApplicationsRemoteDataSourceImpl implements MyApplicationsRemoteDataSource {
  final DioClient _dioClient;
  MyApplicationsRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<MyApplicationDto>> getMyApplications() async {
    try {
      final response = await _dioClient.get(ApiEndpoints.myApplications);
      final List<dynamic> data = response.data['data'];
      return data.map((json) => MyApplicationDto.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          e.response?.data['message'] ?? 'Failed to fetch applications.');
    }
  }
}