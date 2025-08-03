import 'package:get_it/get_it.dart';
import 'package:kamchaiyo/features/home/presentation/view_model/companies/companies_bloc.dart';
import 'package:kamchaiyo/features/home/presentation/view_model/job_feed/job_feed_bloc.dart';

void initHomeInjection(GetIt sl) {
  sl.registerFactory(
    () => CompaniesBloc(getPublicCompaniesUseCase: sl()),
  );
}