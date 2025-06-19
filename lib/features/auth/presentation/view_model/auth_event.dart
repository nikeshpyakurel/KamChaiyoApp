part of 'auth_view_model.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

class AuthCheckRequested extends AuthEvent {}
class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  const LoginRequested({required this.email, required this.password});
  @override
  List<Object> get props => [email, password];
}
class SignupRequested extends AuthEvent {
  final String fullName;
  final String email;
  final String phone;
  final String password;
  const SignupRequested({required this.fullName, required this.email, required this.phone, required this.password});
  @override
  List<Object> get props => [fullName, email, phone, password];
}
class LogoutRequested extends AuthEvent {}