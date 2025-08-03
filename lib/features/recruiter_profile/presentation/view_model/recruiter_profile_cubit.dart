import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamchaiyo/features/auth/domain/use_case/update_profile_usecase.dart';
import 'package:kamchaiyo/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:kamchaiyo/features/recruiter_profile/presentation/view_model/recruiter_profile_state.dart';


class RecruiterProfileCubit extends Cubit<RecruiterProfileState> {
  final UpdateProfileUseCase _updateProfileUseCase;
  final AuthViewModel _authViewModel;

  RecruiterProfileCubit({
    required UpdateProfileUseCase updateProfileUseCase,
    required AuthViewModel authViewModel,
  })  : _updateProfileUseCase = updateProfileUseCase,
        _authViewModel = authViewModel,
        super(const RecruiterProfileState());

  Future<void> updateRecruiterProfile({
    String? fullName,
    File? avatar,
  }) async {
    emit(state.copyWith(status: RecruiterProfileStatus.loading, clearError: true));

    final params = UpdateProfileParams(fullName: fullName, avatar: avatar);
    final result = await _updateProfileUseCase(params);

    result.fold(
      (failure) => emit(state.copyWith(
          status: RecruiterProfileStatus.failure, error: failure.message)),
      (updatedUser) {
       
        _authViewModel.add(UserUpdated(updatedUser));
        emit(state.copyWith(status: RecruiterProfileStatus.success));
      },
    );
  }
}