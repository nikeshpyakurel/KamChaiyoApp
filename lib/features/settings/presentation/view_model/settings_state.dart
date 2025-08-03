part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  final bool isBiometricEnabled;

  const SettingsState({this.isBiometricEnabled = false});

  SettingsState copyWith({bool? isBiometricEnabled}) {
    return SettingsState(
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
    );
  }

  @override
  List<Object> get props => [isBiometricEnabled];
}