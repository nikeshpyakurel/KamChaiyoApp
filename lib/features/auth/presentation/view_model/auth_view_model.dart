import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kamchaiyo/features/auth/domain/entity/user_entity.dart';
import 'package:kamchaiyo/features/auth/domain/use_case/check_auth_status_usecase.dart';
import 'package:kamchaiyo/features/auth/domain/use_case/login_usecase.dart';
import 'package:kamchaiyo/features/auth/domain/use_case/logout_usecase.dart';
import 'package:kamchaiyo/features/auth/domain/use_case/signup_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthViewModel extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final SignupUseCase _signupUseCase;
  final CheckAuthStatusUseCase _checkAuthStatusUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthViewModel({
    required LoginUseCase loginUseCase,
    required SignupUseCase signupUseCase,
    required CheckAuthStatusUseCase checkAuthStatusUseCase,
    required LogoutUseCase logoutUseCase,
  })  : _loginUseCase = loginUseCase, _signupUseCase = signupUseCase, _checkAuthStatusUseCase = checkAuthStatusUseCase, _logoutUseCase = logoutUseCase, super(AuthState.initial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<LoginRequested>(_onLoginRequested);
    on<SignupRequested>(_onSignupRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  void _onAuthCheckRequested(AuthCheckRequested event, Emitter<AuthState> emit) async {
    final result = await _checkAuthStatusUseCase(NoParams());
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, isAuthenticated: false)),
      (user) => emit(state.copyWith(isLoading: false, isAuthenticated: user != null, user: user)),
    );
  }

  void _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    final result = await _loginUseCase(LoginParams(email: event.email, password: event.password));
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, error: failure.message, isAuthenticated: false)),
      (user) => emit(state.copyWith(isLoading: false, isAuthenticated: true, user: user)),
    );
  }

  void _onSignupRequested(SignupRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    final params = SignupParams(fullName: event.fullName, email: event.email, phone: event.phone, password: event.password);
    final result = await _signupUseCase(params);
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, error: failure.message)),
      (_) => emit(state.copyWith(isLoading: false, signupSuccess: true)),
    );
  }

  void _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true));
    await _logoutUseCase(NoParams());
    emit(AuthState.initial().copyWith(isAuthenticated: false));
  }
}