import 'package:flutter_test/flutter_test.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/auth/domain/use_case/check_auth_status_usecase.dart';
import 'package:kamchaiyo/features/home/presentation/view_model/job_feed/job_feed_bloc.dart';
import 'package:kamchaiyo/features/job/domain/entity/job_entity.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../company/domain/use_case/get_job_recommendations_usecase.mock.dart.dart';


void main() {
  late MockGetJobRecommendationsUseCase mockGetJobRecommendationsUseCase;
  late JobFeedBloc jobFeedBloc;

 
  setUpAll(() {
    registerFallbackValue(NoParams());
  });

  setUp(() {
    mockGetJobRecommendationsUseCase = MockGetJobRecommendationsUseCase();
    jobFeedBloc = JobFeedBloc(
        getJobRecommendationsUseCase: mockGetJobRecommendationsUseCase);
  });

  tearDown(() {
    jobFeedBloc.close();
  });

  final tJobs = [
    JobEntity(
      id: '1',
      title: 'Flutter Developer',
      description: 'Test Desc',
      requirements: const ['Dart', 'Flutter'],
      salary: 50000,
      location: 'Kathmandu',
      jobType: 'Full-time',
      experienceLevel: 'Mid-level',
      companyName: 'Test Corp',
      companyId: 'c1',
      createdAt: DateTime.now(),
    ),
  ];
  final tFailure = ServerFailure(message: 'Server Error');

  test('initial state should be JobFeedState()', () {
    expect(jobFeedBloc.state, const JobFeedState());
  });


}