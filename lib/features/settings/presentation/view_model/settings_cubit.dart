import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SharedPreferences _prefs;
  static const String _biometricKey = 'isBiometricEnabled';

  SettingsCubit({required SharedPreferences prefs})
      : _prefs = prefs,
        super(const SettingsState()) {
    _loadSettings();
  }

  void _loadSettings() {
    final isEnabled = _prefs.getBool(_biometricKey) ?? false;
    emit(state.copyWith(isBiometricEnabled: isEnabled));
  }

  Future<void> toggleBiometric(bool isEnabled) async {
    await _prefs.setBool(_biometricKey, isEnabled);
    emit(state.copyWith(isBiometricEnabled: isEnabled));
  }
}