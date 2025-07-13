import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/auth/domain/entity/user_entity.dart';
import 'package:kamchaiyo/features/auth/domain/use_case/check_auth_status_usecase.dart';
import 'package:kamchaiyo/features/auth/domain/use_case/login_usecase.dart';
import 'package:kamchaiyo/features/auth/domain/use_case/logout_usecase.dart';
import 'package:kamchaiyo/features/auth/domain/use_case/signup_usecase.dart';
import 'package:kamchaiyo/features/auth/domain/use_case/update_profile_usecase.dart';
import 'package:kamchaiyo/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}
class MockSignupUseCase extends Mock implements SignupUseCase {}
class MockCheckAuthStatusUseCase extends Mock implements CheckAuthStatusUseCase {}
class MockLogoutUseCase extends Mock implements LogoutUseCase {}
class MockUpdateProfileUseCase extends Mock implements UpdateProfileUseCase {}

void main() {
  late AuthViewModel authViewModel;
  late MockLoginUseCase mockLoginUseCase;
  late MockSignupUseCase mockSignupUseCase;
  late MockCheckAuthStatusUseCase mockCheckAuthStatusUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockUpdateProfileUseCase mockUpdateProfileUseCase;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockSignupUseCase = MockSignupUseCase();
    mockCheckAuthStatusUseCase = MockCheckAuthStatusUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockUpdateProfileUseCase = MockUpdateProfileUseCase();

    authViewModel = AuthViewModel(
      loginUseCase: mockLoginUseCase,
      signupUseCase: mockSignupUseCase,
      checkAuthStatusUseCase: mockCheckAuthStatusUseCase,
      logoutUseCase: mockLogoutUseCase,
      updateProfileUseCase: mockUpdateProfileUseCase,
    );
  });

  tearDown(() {
    authViewModel.close();
  });

  const tUser = UserEntity(id: '1', fullName: 'Test User', email: 'test@test.com', phone: '1234567890', role: 'student');
  const tPassword = 'password123';
  final tLoginParams = LoginParams(email: tUser.email, password: tPassword, role: 'student');
  final tSignupParams = SignupParams(fullName: tUser.fullName, email: tUser.email, phone: tUser.phone, password: tPassword, role: 'student');
  final tServerFailure = ServerFailure(message: 'Server error occurred');

  test('initial state should be AuthState.initial()', () {
    expect(authViewModel.state, AuthState.initial());
  });

  group('LoginRequested', () {
    blocTest<AuthViewModel, AuthState>(
      'should emit [loading, success] when LoginUseCase returns a user',
      build: () {
        // Arrange
        when(() => mockLoginUseCase(tLoginParams)).thenAnswer((_) async => const Right(tUser));
        return authViewModel;
      },
      act: (bloc) => bloc.add(LoginRequested(email: tUser.email, password: tPassword, role: 'student')),
      expect: () => [
        AuthState.initial().copyWith(isLoading: true),
        AuthState.initial().copyWith(isLoading: false, isAuthenticated: true, user: tUser),
      ],
      verify: (_) {
        verify(() => mockLoginUseCase(tLoginParams)).called(1);
      },
    );

    blocTest<AuthViewModel, AuthState>(
      'should emit [loading, failure] when LoginUseCase returns a failure',
      build: () {
        // Arrange
        when(() => mockLoginUseCase(tLoginParams)).thenAnswer((_) async => Left(tServerFailure));
        return authViewModel;
      },
      act: (bloc) => bloc.add(LoginRequested(email: tUser.email, password: tPassword, role: 'student')),
      expect: () => [
        AuthState.initial().copyWith(isLoading: true),
        AuthState.initial().copyWith(isLoading: false, error: tServerFailure.message, isAuthenticated: false),
      ],
      verify: (_) {
        verify(() => mockLoginUseCase(tLoginParams)).called(1);
      },
    );
  });

  group('SignupRequested', () {
    blocTest<AuthViewModel, AuthState>(
      'should emit [loading, success] when SignupUseCase is successful',
      build: () {
        // Arrange
        when(() => mockSignupUseCase(tSignupParams)).thenAnswer((_) async => const Right(tUser));
        return authViewModel;
      },
      act: (bloc) => bloc.add(SignupRequested(fullName: tUser.fullName, email: tUser.email, phone: tUser.phone, password: tPassword, role: 'student')),
      expect: () => [
        AuthState.initial().copyWith(isLoading: true),
        AuthState.initial().copyWith(isLoading: false, signupSuccess: true),
      ],
      verify: (_) {
        verify(() => mockSignupUseCase(tSignupParams)).called(1);
      },
    );

    blocTest<AuthViewModel, AuthState>(
      'should emit [loading, failure] when SignupUseCase returns a failure',
      build: () {
        // Arrange
        when(() => mockSignupUseCase(tSignupParams)).thenAnswer((_) async => Left(tServerFailure));
        return authViewModel;
      },
      act: (bloc) => bloc.add(SignupRequested(fullName: tUser.fullName, email: tUser.email, phone: tUser.phone, password: tPassword, role: 'student')),
      expect: () => [
        AuthState.initial().copyWith(isLoading: true),
        AuthState.initial().copyWith(isLoading: false, error: tServerFailure.message),
      ],
      verify: (_) {
        verify(() => mockSignupUseCase(tSignupParams)).called(1);
      },
    );
  });
  
}