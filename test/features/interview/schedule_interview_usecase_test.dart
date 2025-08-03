import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kamchaiyo/features/interview/domain/entity/interview_entity.dart';
import 'package:kamchaiyo/features/interview/domain/repository/interview_repository.dart';
import 'package:kamchaiyo/features/interview/domain/use_case/schedule_interview_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockInterviewRepository extends Mock implements InterviewRepository {}

void main() {
  group('ScheduleInterviewUseCase', () {
    late ScheduleInterviewUseCase useCase;
    late MockInterviewRepository mockRepository;

    setUp(() {
      mockRepository = MockInterviewRepository();
      useCase = ScheduleInterviewUseCase(mockRepository);
    });

    test('should schedule interview successfully', () async {
      final params = ScheduleInterviewParams(
        applicationId: 'app123',
        interviewType: 'Technical',
        date: DateTime(2024, 1, 15),
        time: '10:00 AM',
        locationOrLink: 'https://meet.google.com/abc-defg-hij',
      );
      
      const expectedInterview = InterviewEntity(id: 'interview123');
      
      when(() => mockRepository.scheduleInterview(params))
          .thenAnswer((_) async => const Right(expectedInterview));

      final result = await useCase(params);

      expect(result, const Right(expectedInterview));
      verify(() => mockRepository.scheduleInterview(params)).called(1);
    });
  });
} 