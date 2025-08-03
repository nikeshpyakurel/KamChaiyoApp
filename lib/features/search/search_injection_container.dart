import 'package:get_it/get_it.dart';
import 'package:kamchaiyo/features/search/view_model/search_bloc.dart';

void initSearchInjection(GetIt sl) {
  sl.registerFactory(
    () => SearchBloc(searchJobsUseCase: sl()),
  );
}