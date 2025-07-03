import 'dart:io';
import 'package:dio/dio.dart';
import 'package:kamchaiyo/core/error/exception.dart';
import 'package:kamchaiyo/core/network/api_endpoints.dart';
import 'package:kamchaiyo/core/network/dio_client.dart';
import 'package:kamchaiyo/features/auth/data/dto/login_response_dto.dart';
import 'package:kamchaiyo/features/auth/data/dto/user_dto.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseDto> login(String email, String password, String role);
  Future<UserDto> register({required String fullName, required String email, required String phone, required String password, required String role});
  Future<UserDto> updateProfile({String? fullName, File? avatar, File? resume});
  Future<UserDto> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;
  AuthRemoteDataSourceImpl(this._dioClient);

  @override
  Future<LoginResponseDto> login(String email, String password, String role) async {
    try {
      final response = await _dioClient.post(ApiEndpoints.login, data: {"email": email, "password": password, "role": role});
      return LoginResponseDto.fromJson(response.data["data"]);
    } on DioException catch (e) { throw ServerException(e.response?.data['message'] ?? 'Login failed.'); }
  }

  @override
  Future<UserDto> register({required String fullName, required String email, required String phone, required String password, required String role}) async {
    try {
      final response = await _dioClient.post(ApiEndpoints.register, data: {"fullName": fullName, "email": email, "phoneNumber": phone, "password": password, "role": role});
      return UserDto.fromJson(response.data["data"]);
    } on DioException catch (e) { throw ServerException(e.response?.data['message'] ?? 'Registration failed.'); }
  }

  @override
  Future<UserDto> getCurrentUser() async {
    try {
      final response = await _dioClient.get(ApiEndpoints.currentUser);
      return UserDto.fromJson(response.data["data"]);
    } on DioException catch (e) { throw ServerException(e.response?.data['message'] ?? 'Failed to fetch user.'); }
  }
  
  @override
  Future<UserDto> updateProfile({String? fullName, File? avatar, File? resume}) async {
    try {
      final formData = FormData.fromMap({ if (fullName != null) 'fullName': fullName, if (avatar != null) 'avatar': await MultipartFile.fromFile(avatar.path), if (resume != null) 'resume': await MultipartFile.fromFile(resume.path) });
      final response = await _dioClient.patch(ApiEndpoints.updateProfile, data: formData);
      return UserDto.fromJson(response.data["data"]);
    } on DioException catch (e) { throw ServerException(e.response?.data['message'] ?? 'Profile update failed.'); }
  }
}