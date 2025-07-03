import 'package:dio/dio.dart';
import 'package:kamchaiyo/core/error/exception.dart';
import 'package:kamchaiyo/core/network/api_endpoints.dart';
import 'package:kamchaiyo/core/network/dio_client.dart';
import 'package:kamchaiyo/features/admin/data/dto/chatbot_setting_dto.dart';
import 'package:kamchaiyo/features/admin/data/dto/company_dto.dart';
import 'package:kamchaiyo/features/auth/data/dto/user_dto.dart';

abstract class AdminRemoteDataSource {
  Future<List<UserDto>> getAllUsers();
  Future<List<CompanyDto>> getAllCompanies();
  Future<CompanyDto> toggleCompanyVerification(String companyId);
  Future<ChatbotSettingDto> getChatbotSettings();
  Future<ChatbotSettingDto> updateChatbotSettings(String newPrompt);
}

class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  final DioClient _dioClient;
  AdminRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<UserDto>> getAllUsers() async {
    try {
      final response = await _dioClient.get(ApiEndpoints.adminGetAllUsers);
      final List<dynamic> userList = response.data['data'];
      return userList.map((json) => UserDto.fromJson(json)).toList();
    } on DioException catch (e) { throw ServerException(e.response?.data['message'] ?? 'Failed to fetch users.'); }
  }

  @override
  Future<List<CompanyDto>> getAllCompanies() async {
    try {
      final response = await _dioClient.get(ApiEndpoints.adminGetAllCompanies);
      final List<dynamic> companyList = response.data['data'];
      return companyList.map((json) => CompanyDto.fromJson(json)).toList();
    } on DioException catch (e) { throw ServerException(e.response?.data['message'] ?? 'Failed to fetch companies.'); }
  }
  
  @override
  Future<CompanyDto> toggleCompanyVerification(String companyId) async {
    try {
      final url = '${ApiEndpoints.adminCompanies}/$companyId/toggle-verification';
      final response = await _dioClient.patch(url);
      return CompanyDto.fromJson(response.data['data']);
    } on DioException catch (e) { throw ServerException(e.response?.data['message'] ?? 'Failed to toggle verification.'); }
  }

  @override
  Future<ChatbotSettingDto> getChatbotSettings() async {
    try {
      final response = await _dioClient.get(ApiEndpoints.adminChatbotSettings);
      return ChatbotSettingDto.fromJson(response.data['data']);
    } on DioException catch (e) { throw ServerException(e.response?.data['message'] ?? 'Failed to get settings.'); }
  }
  
  @override
  Future<ChatbotSettingDto> updateChatbotSettings(String newPrompt) async {
    try {
      final response = await _dioClient.put(ApiEndpoints.adminChatbotSettings, data: {'systemPrompt': newPrompt});
      return ChatbotSettingDto.fromJson(response.data['data']);
    } on DioException catch (e) { throw ServerException(e.response?.data['message'] ?? 'Failed to update settings.'); }
  }
}