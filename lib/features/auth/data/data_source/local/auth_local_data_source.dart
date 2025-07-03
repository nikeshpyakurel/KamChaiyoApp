import 'package:kamchaiyo/features/auth/data/model/auth_hive_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AuthLocalDataSource {
  final SharedPreferences _sharedPreferences;
  final Box<AuthHiveModel> _userBox;
  AuthLocalDataSource(this._sharedPreferences, this._userBox);

  static const String _accessTokenKey = 'accessToken';
  Future<void> saveToken(String token) async => await _sharedPreferences.setString(_accessTokenKey, token);
  Future<String?> getToken() async => _sharedPreferences.getString(_accessTokenKey);
  Future<void> clearToken() async => await _sharedPreferences.remove(_accessTokenKey);
  Future<void> cacheUser(AuthHiveModel user) async => await _userBox.put('currentUser', user);
  Future<AuthHiveModel?> getCachedUser() async => _userBox.get('currentUser');
  Future<void> clearCache() async => await _userBox.delete('currentUser');
}