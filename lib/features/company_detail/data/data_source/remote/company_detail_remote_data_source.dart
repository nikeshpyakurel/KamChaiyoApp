import 'package:dio/dio.dart';
import 'package:kamchaiyo/core/error/exception.dart';
import 'package:kamchaiyo/core/network/api_endpoints.dart';
import 'package:kamchaiyo/core/network/dio_client.dart';
import 'package:kamchaiyo/features/company_detail/data/dto/company_detail_dto.dart';

abstract class CompanyDetailRemoteDataSource {
  Future<CompanyDetailDto> getCompanyDetail(String companyId);
}

class CompanyDetailRemoteDataSourceImpl implements CompanyDetailRemoteDataSource {
  final DioClient _dioClient;
  CompanyDetailRemoteDataSourceImpl(this._dioClient);

  @override
  Future<CompanyDetailDto> getCompanyDetail(String companyId) async {
    try {
      final response = await _dioClient.get('${ApiEndpoints.publicCompanyDetail}$companyId');
      return CompanyDetailDto.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException(
          e.response?.data['message'] ?? 'Failed to fetch company details.');
    }
  }
}