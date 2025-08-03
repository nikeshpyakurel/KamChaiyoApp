import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/company/domain/entity/company_entity.dart';
import 'package:kamchaiyo/features/company/domain/use_case/update_company_usecase.dart';
import 'package:mocktail/mocktail.dart';

import '../repository/company_repo.mock.dart';

class MockFile extends Mock implements File {}

void main() {
  late MockCompanyRepository mockRepository;
  late UpdateCompanyUseCase usecase;
  late UpdateCompanyParams tParams;

  setUp(() {
    mockRepository = MockCompanyRepository();
    usecase = UpdateCompanyUseCase(mockRepository);
    tParams = const UpdateCompanyParams(id: '1', name: 'Updated Name');
  });

  const tCompany = CompanyEntity(id: '1', name: 'Updated Name', verified: false);
  final tFailure = ServerFailure(message: 'Update failed');
  
  setUpAll(() {
    registerFallbackValue(const UpdateCompanyParams(id: 'fallback', name: 'fallback'));
  });

  test(
    'should call the repository to update a company and return it on success',
    () async {
      when(() => mockRepository.updateCompany(any()))
          .thenAnswer((_) async => const Right(tCompany));

      final result = await usecase(tParams);

      expect(result, const Right(tCompany));
      verify(() => mockRepository.updateCompany(tParams)).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'should return a Failure when company update fails',
    () async {
      when(() => mockRepository.updateCompany(any()))
          .thenAnswer((_) async => Left(tFailure));

      final result = await usecase(tParams);

      expect(result, Left(tFailure));
      verify(() => mockRepository.updateCompany(tParams)).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
