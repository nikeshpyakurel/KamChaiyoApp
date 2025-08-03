import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/company/domain/use_case/delete_company_usecase.dart';
import 'package:mocktail/mocktail.dart';

import '../repository/company_repo.mock.dart';

void main() {
  late MockCompanyRepository mockRepository;
  late DeleteCompanyUseCase usecase;

  setUp(() {
    mockRepository = MockCompanyRepository();
    usecase = DeleteCompanyUseCase(mockRepository);
  });

  const tCompanyId = '1';
  final tFailure = ServerFailure(message: 'Delete failed');

  test(
    'should call the repository to delete a company and return void on success',
    () async {
      // Arrange
      when(() => mockRepository.deleteCompany(any()))
          .thenAnswer((_) async => const Right(null)); // Right(null) represents Right<void>

      // Act
      final result = await usecase(tCompanyId);

      // Assert
      expect(result, const Right(null));
      verify(() => mockRepository.deleteCompany(tCompanyId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'should return a Failure when company deletion fails',
    () async {
      // Arrange
      when(() => mockRepository.deleteCompany(any()))
          .thenAnswer((_) async => Left(tFailure));

      // Act
      final result = await usecase(tCompanyId);

      // Assert
      expect(result, Left(tFailure));
      verify(() => mockRepository.deleteCompany(tCompanyId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
