import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/company/domain/entity/company_entity.dart';
import 'package:kamchaiyo/features/company/domain/use_case/get_my_companies_usecase.dart';
import 'package:mocktail/mocktail.dart';

import '../repository/company_repo.mock.dart';

class MockFile extends Mock implements File {}

void main() {
  late MockCompanyRepository mockRepository;
  late CreateCompanyUseCase usecase;
  late CreateCompanyParams tParams;

  setUp(() {
    mockRepository = MockCompanyRepository();
    usecase = CreateCompanyUseCase(mockRepository);
    tParams = CreateCompanyParams(name: 'New Company', description: 'A test company', logo: MockFile());
  });

  const tCompany = CompanyEntity(id: '3', name: 'New Company', verified: false, description: 'A test company');
  final tFailure = ServerFailure(message: 'Could not create company');
  
  setUpAll(() {
    registerFallbackValue(CreateCompanyParams(name: 'fallback'));
  });

  test(
    'should call the repository to create a company and return it on success',
    () async {
      when(() => mockRepository.createCompany(any()))
          .thenAnswer((_) async => const Right(tCompany));

      final result = await usecase(tParams);

      expect(result, const Right(tCompany));
      verify(() => mockRepository.createCompany(tParams)).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'should return a Failure when company creation fails',
    () async {
      when(() => mockRepository.createCompany(any()))
          .thenAnswer((_) async => Left(tFailure));

      final result = await usecase(tParams);

      expect(result, Left(tFailure));
      verify(() => mockRepository.createCompany(tParams)).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
