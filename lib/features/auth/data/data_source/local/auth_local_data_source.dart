import 'package:hive_flutter/hive_flutter.dart';
import 'package:kamchaiyo/app/constant/hive_table_constant.dart';
import 'package:kamchaiyo/core/network/hive_service.dart'; 
import 'package:kamchaiyo/features/auth/data/model/auth_hive_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSource {
  final SharedPreferences _sharedPreferences;
  final HiveService _hiveService; 


  Box<AuthHiveModel> get _sessionBox => Hive.box<AuthHiveModel>(HiveTableConstant.sessionBox);

  AuthLocalDataSource(this._sharedPreferences, this._hiveService);

  static const String _accessTokenKey = 'accessToken';
  static const String _currentUserKey = 'currentUser';

  Future<void> saveToken(String token) async {
    await _sharedPreferences.setString(_accessTokenKey, token);
  }

  Future<String?> getToken() async {
    return _sharedPreferences.getString(_accessTokenKey);
  }

  Future<void> clearToken() async {
    await _sharedPreferences.remove(_accessTokenKey);
  }

  Future<void> cacheUser(AuthHiveModel user) async {
    await _sessionBox.put(_currentUserKey, user);
  }

  Future<AuthHiveModel?> getCachedUser() async {
    return _sessionBox.get(_currentUserKey);
  }

  Future<void> clearCache() async {
    await _sessionBox.clear();
  }
}