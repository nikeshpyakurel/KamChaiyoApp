import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kamchaiyo/app/use_case/usecase.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/auth/domain/use_case/check_auth_status_usecase.dart';
import 'package:kamchaiyo/features/company/domain/entity/company_entity.dart';
import 'package:kamchaiyo/features/company/domain/use_case/get_public_companies_usecase.dart';
import 'package:mocktail/mocktail.dart';

import '../repository/company_repo.mock.dart';

void main() {
  late MockCompanyRepository mockRepository;
  late GetPublicCompaniesUseCase usecase;

  setUp(() {
    mockRepository = MockCompanyRepository();
    usecase = GetPublicCompaniesUseCase(mockRepository);
  });

  const tCompanies = [
    CompanyEntity(id: '1', name: 'Public Tech', verified: true),
    CompanyEntity(id: '2', name: 'Open Source Inc', verified: true),
  ];
  final tFailure = ServerFailure(message: 'Server error');

  test(
    'should get the list of public companies from the repository',
    () async {
      when(() => mockRepository.getPublicCompanies())
          .thenAnswer((_) async => const Right(tCompanies));

      final result = await usecase(NoParams());

      expect(result, const Right(tCompanies));
      verify(() => mockRepository.getPublicCompanies()).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'should return a Failure when getting public companies fails',
    () async {
      when(() => mockRepository.getPublicCompanies())
          .thenAnswer((_) async => Left(tFailure));

      final result = await usecase(NoParams());

      expect(result, Left(tFailure));
      verify(() => mockRepository.getPublicCompanies()).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
