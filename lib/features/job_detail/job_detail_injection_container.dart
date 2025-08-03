import 'package:get_it/get_it.dart';
import 'package:kamchaiyo/features/job_detail/presentation/view_model/job_detail_bloc.dart';

void initJobDetailInjection(GetIt sl) {
  sl.registerFactory(
    () => JobDetailBloc(
      getJobByIdUseCase: sl(),
      applyForJobUseCase: sl(),
    ),
  );
}