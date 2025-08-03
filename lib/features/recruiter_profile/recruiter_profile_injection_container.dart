import 'package:get_it/get_it.dart';
import 'package:kamchaiyo/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:kamchaiyo/features/auth/domain/use_case/update_profile_usecase.dart';
import 'package:kamchaiyo/features/recruiter_profile/presentation/view_model/recruiter_profile_cubit.dart';

void initRecruiterProfileInjection(GetIt sl) {
  sl.registerFactory(
    () => RecruiterProfileCubit(
      updateProfileUseCase: sl<UpdateProfileUseCase>(),
      authViewModel: sl<AuthViewModel>(),
    ),
  );
}