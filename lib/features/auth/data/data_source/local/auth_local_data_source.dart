import 'package:hive/hive.dart';
import 'package:kamchaiyo/core/error/exception.dart';
import 'package:kamchaiyo/features/auth/data/model/auth_hive_model.dart';

class AuthLocalDataSource {
  final Box<AuthHiveModel> _userBox;
  final Box<AuthHiveModel> _sessionBox;

  AuthLocalDataSource(this._userBox, this._sessionBox);

  Future<void> signup(AuthHiveModel user) async {
    final userExists = _userBox.values.any((u) => u.email == user.email);
    if (userExists) {
      throw const CacheException('User with this email already exists.');
    }
    await _userBox.add(user);
  }

  Future<AuthHiveModel> login(String email, String password) async {
    final user = _userBox.values.firstWhere(
      (u) => u.email == email && u.password == password,
      orElse: () => throw const CacheException('Invalid credentials.'),
    );
    await _sessionBox.put('currentUser', user);
    return user;
  }

  Future<AuthHiveModel?> getCachedUser() async {
    return _sessionBox.get('currentUser');
  }

  Future<void> logout() async {
    await _sessionBox.delete('currentUser');
  }
}