part of 'auth_view_model.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}
class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  final String role;
  const LoginRequested({required this.email, required this.password, required this.role});
  @override
  List<Object> get props => [email, password, role];
}
class SignupRequested extends AuthEvent {
  final String fullName;
  final String email;
  final String phone;
  final String password;
  final String role;
  const SignupRequested({required this.fullName, required this.email, required this.phone, required this.password, required this.role});
  @override
  List<Object> get props => [fullName, email, phone, password, role];
}
class LogoutRequested extends AuthEvent {}
class UpdateProfileRequested extends AuthEvent {
  final UpdateProfileParams params;
  const UpdateProfileRequested(this.params);
  @override
  List<Object?> get props => [params];
}