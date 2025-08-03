import 'package:dio/dio.dart';
import 'package:kamchaiyo/core/error/exception.dart';
import 'package:kamchaiyo/core/network/api_endpoints.dart';
import 'package:kamchaiyo/core/network/dio_client.dart';
import 'package:kamchaiyo/features/user_profile/data/dto/user_profile_dto.dart';

abstract class UserProfileRemoteDataSource {
  Future<UserProfileDto> getUserProfile(String userId);
}

class UserProfileRemoteDataSourceImpl implements UserProfileRemoteDataSource {
  final DioClient _dioClient;
  UserProfileRemoteDataSourceImpl(this._dioClient);

  @override
  Future<UserProfileDto> getUserProfile(String userId) async {
    try {
      final response = await _dioClient.get('${ApiEndpoints.userProfile}/$userId');
      return UserProfileDto.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Failed to fetch user profile.');
    }
  }
}