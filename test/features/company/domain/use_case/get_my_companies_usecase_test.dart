import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kamchaiyo/app/use_case/usecase.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/auth/domain/use_case/check_auth_status_usecase.dart';
import 'package:kamchaiyo/features/company/domain/entity/company_entity.dart';
import 'package:kamchaiyo/features/company/domain/use_case/create_company_usecase.dart';
import 'package:kamchaiyo/features/company/domain/use_case/get_my_companies_usecase.dart';
import 'package:mocktail/mocktail.dart';

import '../repository/company_repo.mock.dart';

void main() {
  late MockCompanyRepository mockRepository;
  late GetMyCompaniesUseCase usecase;

  setUp(() {
    mockRepository = MockCompanyRepository();
    usecase = GetMyCompaniesUseCase(mockRepository);
  });

  const tCompanies = [
    CompanyEntity(id: '1', name: 'Tech Solutions', verified: true),
    CompanyEntity(id: '2', name: 'Innovate Hub', verified: false),
  ];
  final tFailure = ServerFailure(message: 'Server error occurred');

  test(
    'should get the list of companies for the current user from the repository',
    () async {
      when(() => mockRepository.getMyCompanies())
          .thenAnswer((_) async => const Right(tCompanies));

      final result = await usecase(NoParams());

      expect(result, const Right(tCompanies));
      verify(() => mockRepository.getMyCompanies()).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'should return a Failure when getting my companies fails',
    () async {
      when(() => mockRepository.getMyCompanies())
          .thenAnswer((_) async => Left(tFailure));

      final result = await usecase(NoParams());

      expect(result, Left(tFailure));
      verify(() => mockRepository.getMyCompanies()).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
