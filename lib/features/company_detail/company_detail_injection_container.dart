import 'package:get_it/get_it.dart';
import 'package:kamchaiyo/features/company_detail/data/data_source/remote/company_detail_remote_data_source.dart';
import 'package:kamchaiyo/features/company_detail/data/repository/company_detail_repository_impl.dart';
import 'package:kamchaiyo/features/company_detail/domain/repository/company_detail_repository.dart';
import 'package:kamchaiyo/features/company_detail/domain/use_case/get_company_detail_usecase.dart';
import 'package:kamchaiyo/features/company_detail/presentation/view_model/company_detail_bloc.dart';

void initCompanyDetailInjection(GetIt sl) {
  sl.registerFactory(() => CompanyDetailBloc(getCompanyDetailUseCase: sl()));

  sl.registerLazySingleton(() => GetCompanyDetailUseCase(sl()));

  sl.registerLazySingleton<CompanyDetailRepository>(
      () => CompanyDetailRepositoryImpl(remoteDataSource: sl()));

  sl.registerLazySingleton<CompanyDetailRemoteDataSource>(
      () => CompanyDetailRemoteDataSourceImpl(sl()));
}