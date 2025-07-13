import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kamchaiyo/features/auth/domain/entity/user_entity.dart'; // Assuming UserEntity is in this path
import 'package:kamchaiyo/features/auth/domain/use_case/login_usecase.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late AuthRepoMock repository;
  late LoginUseCase usecase;

  const user = UserEntity(id: '1', fullName: 'Nikesh Pyakurel', email: "nikesh@gmail.com", phone: "9800000000", role: "user");

  setUp(() {
    repository = AuthRepoMock();
    usecase = LoginUseCase(repository);
  });

  test(
    'should call login with correct email, password, and role',
    () async {
      // Arrange
      when(
        () => repository.login(any(), any(), any()),
      ).thenAnswer((_) async => const Right(user));

      // Act
      final result = await usecase(
        const LoginParams(email: 'nikesh@gmail.com', password: 'nikesh123', role: "user"),
      );

      expect(result, const Right(user));

      verify(() => repository.login('nikesh@gmail.com', 'nikesh123', 'user')).called(1);
      verifyNoMoreInteractions(repository);
    },
  );

  tearDown(() {
    reset(repository);
  });
}