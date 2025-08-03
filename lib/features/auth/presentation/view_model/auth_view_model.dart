import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kamchaiyo/app/service_locator/service_locator.dart';
import 'package:kamchaiyo/core/network/socket_service.dart';
import 'package:kamchaiyo/features/auth/data/data_source/local/auth_local_data_source.dart';
import 'package:kamchaiyo/features/auth/domain/entity/user_entity.dart';
import 'package:kamchaiyo/features/auth/domain/use_case/check_auth_status_usecase.dart';
import 'package:kamchaiyo/features/auth/domain/use_case/login_usecase.dart';
import 'package:kamchaiyo/features/auth/domain/use_case/logout_usecase.dart';
import 'package:kamchaiyo/features/auth/domain/use_case/signup_usecase.dart';
import 'package:kamchaiyo/features/auth/domain/use_case/update_profile_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthViewModel extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final SignupUseCase _signupUseCase;
  final CheckAuthStatusUseCase _checkAuthStatusUseCase;
  final LogoutUseCase _logoutUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;

  final SocketService _socketService = SocketService();


  AuthViewModel({
    required LoginUseCase loginUseCase,
    required SignupUseCase signupUseCase,
    required CheckAuthStatusUseCase checkAuthStatusUseCase,
    required LogoutUseCase logoutUseCase,
    required UpdateProfileUseCase updateProfileUseCase,
  })  : _loginUseCase = loginUseCase, _signupUseCase = signupUseCase, _checkAuthStatusUseCase = checkAuthStatusUseCase, _logoutUseCase = logoutUseCase, _updateProfileUseCase = updateProfileUseCase, super(AuthState.initial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<LoginRequested>(_onLoginRequested);
    on<SignupRequested>(_onSignupRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<UpdateProfileRequested>(_onUpdateProfileRequested);
    on<UserUpdated>(_onUserUpdated); 
    
  }

  void _onAuthCheckRequested(AuthCheckRequested event, Emitter<AuthState> emit) async {
    final result = await _checkAuthStatusUseCase(NoParams());
    
    await result.fold(
      (failure) async => emit(state.copyWith(isLoading: false, isAuthenticated: false)),
      (user) async {
        if (user != null) {
          // If the user is already logged in, get the token and connect the socket
          final token = await sl<AuthLocalDataSource>().getToken();
          if (token != null) {
            _socketService.connect(token);
          }
        }
        emit(state.copyWith(isLoading: false, isAuthenticated: user != null, user: user));
      },
    );
  }

  void _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    final result = await _loginUseCase(
        LoginParams(email: event.email, password: event.password, role: event.role));
    
    await result.fold(
      (failure) async => emit(state.copyWith(isLoading: false, error: failure.message, isAuthenticated: false)),
      (user) async {
        final token = await sl<AuthLocalDataSource>().getToken();
        if (token != null) {
          _socketService.connect(token);
        }
        emit(state.copyWith(isLoading: false, isAuthenticated: true, user: user));
      },
    );
  }

  void _onSignupRequested(SignupRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    final params = SignupParams(fullName: event.fullName, email: event.email, phone: event.phone, password: event.password, role: event.role);
    final result = await _signupUseCase(params);
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, error: failure.message)),
      (_) => emit(state.copyWith(isLoading: false, signupSuccess: true)),
    );
  }

  void _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true));
    
    _socketService.disconnect();
    
    await _logoutUseCase(NoParams());
    emit(AuthState.initial().copyWith(isAuthenticated: false));
  }

  void _onUpdateProfileRequested(UpdateProfileRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true, error: null, profileUpdateSuccess: false));
    final result = await _updateProfileUseCase(event.params);
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, error: failure.message)),
      (user) => emit(state.copyWith(isLoading: false, profileUpdateSuccess: true, user: user)),
    );
  }

  void _onUserUpdated(UserUpdated event, Emitter<AuthState> emit) {
    emit(state.copyWith(user: event.updatedUser, profileUpdateSuccess: false));
  }
}