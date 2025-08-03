import 'dart:io';
import 'package:dio/dio.dart';
import 'package:kamchaiyo/core/error/exception.dart';
import 'package:kamchaiyo/core/network/api_endpoints.dart';
import 'package:kamchaiyo/core/network/dio_client.dart';
import 'package:kamchaiyo/features/company/data/dto/company_dto.dart';

abstract class CompanyRemoteDataSource {
   
  Future<List<CompanyDto>> getMyCompanies();
   Future<CompanyDto> updateCompany({required String companyId, required String name, String? description, String? website, String? location, File? logo});
  Future<void> deleteCompany(String companyId);
  Future<CompanyDto> createCompany({
    required String name,
    String? description,
    String? website,
    String? location,
    File? logo,
  });
    Future<List<CompanyDto>> getPublicCompanies(); // New

}

class CompanyRemoteDataSourceImpl implements CompanyRemoteDataSource {
  final DioClient _dioClient;
  CompanyRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<CompanyDto>> getMyCompanies() async {
    try {
      final response = await _dioClient.get(ApiEndpoints.company);
      final List<dynamic> companyList = response.data['data'];
      return companyList.map((json) => CompanyDto.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          e.response?.data['message'] ?? 'Failed to fetch your companies.');
    }
  }

  @override
  Future<CompanyDto> createCompany({
    required String name,
    String? description,
    String? website,
    String? location,
    File? logo,
  }) async {
    try {
      final formData = FormData.fromMap({
        'name': name,
        if (description != null && description.isNotEmpty)
          'description': description,
        if (website != null && website.isNotEmpty) 'website': website,
        if (location != null && location.isNotEmpty) 'location': location,
        if (logo != null) 'logo': await MultipartFile.fromFile(logo.path),
      });

      final response =
          await _dioClient.post(ApiEndpoints.company, data: formData);
      return CompanyDto.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException(
          e.response?.data['message'] ?? 'Failed to create company.');
    }
  }

  @override
  Future<CompanyDto> updateCompany({
    required String companyId,
    required String name,
    String? description,
    String? website,
    String? location,
    File? logo,
  }) async {
    try {
      final formData = FormData.fromMap({
        'name': name,
        if (description != null) 'description': description,
        if (website != null) 'website': website,
        if (location != null) 'location': location,
        if (logo != null) 'logo': await MultipartFile.fromFile(logo.path),
      });

      final response = await _dioClient.patch('${ApiEndpoints.company}/$companyId', data: formData);
      return CompanyDto.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Failed to update company.');
    }
  }

  @override
  Future<void> deleteCompany(String companyId) async {
    try {
      await _dioClient.delete('${ApiEndpoints.company}/$companyId');
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Failed to delete company.');
    }
  }


  @override
  Future<List<CompanyDto>> getPublicCompanies() async {
    try {
      final response = await _dioClient.get(ApiEndpoints.publicCompanies);
      final List<dynamic> companyList = response.data['data'];
      return companyList.map((json) => CompanyDto.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
          e.response?.data['message'] ?? 'Failed to fetch public companies.');
    }
  }
}