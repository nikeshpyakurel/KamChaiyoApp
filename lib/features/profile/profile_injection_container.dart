import 'package:get_it/get_it.dart';
import 'package:kamchaiyo/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:kamchaiyo/features/profile/presentation/view_model/profile_bloc.dart';

void initProfileInjection(GetIt sl) {
  sl.registerFactory(
    () => ProfileBloc(
      updateProfileUseCase: sl(),
      authViewModel: sl<AuthViewModel>(), 
    ),
  );
}