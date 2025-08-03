import 'package:equatable/equatable.dart';
import 'package:kamchaiyo/features/user_profile/domain/entity/user_profile_entity.dart';

enum UserProfileStatus { initial, loading, success, failure }

class UserProfileState extends Equatable{
  final UserProfileStatus status;
  final UserProfileEntity? userProfile;
  final String? error;

  const UserProfileState({
    this.status = UserProfileStatus.initial,
    this.userProfile,
    this.error,
  });

  UserProfileState copyWith({
    UserProfileStatus? status,
    UserProfileEntity? userProfile,
    String? error,
  }) {
    return UserProfileState(
      status: status ?? this.status,
      userProfile: userProfile ?? this.userProfile,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, userProfile, error];
}