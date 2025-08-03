import 'package:get_it/get_it.dart';
import 'package:kamchaiyo/features/interview/data/data_source/remote/interview_remote_data_source.dart';
import 'package:kamchaiyo/features/interview/data/repository/interview_repository_impl.dart';
import 'package:kamchaiyo/features/interview/domain/repository/interview_repository.dart';
import 'package:kamchaiyo/features/interview/domain/use_case/schedule_interview_usecase.dart';
import 'package:kamchaiyo/features/interview/presentation/view_model/interview_view_model.dart';

void initInterviewInjection(GetIt sl) {
  sl.registerFactory(() => InterviewViewModel(scheduleInterviewUseCase: sl()));
  sl.registerLazySingleton(() => ScheduleInterviewUseCase(sl()));
  sl.registerLazySingleton<InterviewRepository>(
      () => InterviewRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<InterviewRemoteDataSource>(
      () => InterviewRemoteDataSourceImpl(sl()));
}