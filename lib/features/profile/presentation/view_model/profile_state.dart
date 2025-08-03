part of 'profile_bloc.dart';

enum ProfileStatus { initial, loading, success, failure }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final String? error;
  final String? successMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.error,
    this.successMessage,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    String? error,
    String? successMessage,
    bool clearMessages = false,
  }) {
    return ProfileState(
      status: status ?? this.status,
      error: clearMessages ? null : error,
      successMessage: clearMessages ? null : successMessage,
    );
  }

  @override
  List<Object?> get props => [status, error, successMessage];
}