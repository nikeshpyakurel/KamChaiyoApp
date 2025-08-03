import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kamchaiyo/features/job/domain/entity/job_entity.dart';
import 'package:kamchaiyo/features/job/domain/repository/job_repository.dart';
import 'package:kamchaiyo/features/job/domain/use_case/get_job_by_id_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockJobRepository extends Mock implements JobRepository {}

void main() {
  group('GetJobByIdUseCase', () {
    late GetJobByIdUseCase useCase;
    late MockJobRepository mockRepository;

    setUp(() {
      mockRepository = MockJobRepository();
      useCase = GetJobByIdUseCase(mockRepository);
    });

    test('should get job by id successfully', () async {
      const jobId = 'job123';
      final expectedJob = JobEntity(
        id: jobId,
        title: 'Software Engineer',
        description: 'We are looking for a skilled software engineer...',
        requirements: ['Flutter', 'Dart', 'Firebase'],
        salary: 80000,
        location: 'New York',
        jobType: 'Full-time',
        experienceLevel: 'Mid-level',
        companyName: 'Tech Corp',
        companyId: 'company123',
        createdAt: DateTime(2024, 1, 1),
      );
      
      when(() => mockRepository.getJobById(jobId))
          .thenAnswer((_) async => Right(expectedJob));

      final result = await useCase(jobId);

      expect(result, Right(expectedJob));
      verify(() => mockRepository.getJobById(jobId)).called(1);
    });
  });
} 