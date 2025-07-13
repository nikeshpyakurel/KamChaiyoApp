import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kamchaiyo/features/auth/domain/entity/user_entity.dart';
import 'package:kamchaiyo/features/auth/domain/use_case/signup_usecase.dart';
import 'package:mocktail/mocktail.dart';
import 'auth_repo.mock.dart';

void main() {
  late AuthRepoMock mockAuthRepository;
  late SignupUseCase signupUseCase;

  const tSignupParams = SignupParams(
    fullName: 'Test User',
    email: 'test@example.com',
    phone: '1234567890',
    password: 'password123',
    role: 'user',
  );

  const tUserEntity = UserEntity(
    id: '1',
    fullName: 'Test User',
    email: 'test@example.com',
    phone: '1234567890',
    role: 'user',
  );

  setUp(() {
    mockAuthRepository = AuthRepoMock();
    signupUseCase = SignupUseCase(mockAuthRepository);
  });

  group('SignupUseCase', () {
    test(
      'should call [AuthRepository.register] with the correct data '
      'and return a [UserEntity] on success',
      () async {
        // Arrange 
        when(
          () => mockAuthRepository.register(
            fullName: any(named: 'fullName'),
            email: any(named: 'email'),
            phone: any(named: 'phone'),
            password: any(named: 'password'),
            role: any(named: 'role'),
          ),
        ).thenAnswer((_) async => const Right(tUserEntity));

        // Act 
        final result = await signupUseCase(tSignupParams);

        // Assert
        expect(result, const Right(tUserEntity));

        verify(
          () => mockAuthRepository.register(
            fullName: tSignupParams.fullName,
            email: tSignupParams.email,
            phone: tSignupParams.phone,
            password: tSignupParams.password,
            role: tSignupParams.role,
          ),
        ).called(1);

        verifyNoMoreInteractions(mockAuthRepository);
      },
    );
  });
}