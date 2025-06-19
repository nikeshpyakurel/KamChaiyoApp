part of 'auth_view_model.dart';

class AuthState extends Equatable {
  final bool isLoading;
  final bool isAuthenticated;
  final UserEntity? user;
  final String? error;
  final bool signupSuccess;

  const AuthState({required this.isLoading, this.isAuthenticated = false, this.user, this.error, this.signupSuccess = false});

  factory AuthState.initial() => const AuthState(isLoading: false);

  AuthState copyWith({bool? isLoading, bool? isAuthenticated, UserEntity? user, String? error, bool? signupSuccess}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      error: error,
      signupSuccess: signupSuccess ?? false,
    );
  }
  @override
  List<Object?> get props => [isLoading, isAuthenticated, user, error, signupSuccess];
}