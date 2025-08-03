import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamchaiyo/features/auth/domain/use_case/update_profile_usecase.dart';
import 'package:kamchaiyo/features/auth/presentation/view_model/auth_view_model.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UpdateProfileUseCase _updateProfileUseCase;
  final AuthViewModel _authViewModel;

  ProfileBloc({
    required UpdateProfileUseCase updateProfileUseCase,
    required AuthViewModel authViewModel,
  })  : _updateProfileUseCase = updateProfileUseCase,
        _authViewModel = authViewModel,
        super(const ProfileState()) {
    on<ProfileUpdateSubmitted>(_onProfileUpdateSubmitted);
  }

  Future<void> _onProfileUpdateSubmitted(
    ProfileUpdateSubmitted event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading, clearMessages: true));

    final params = UpdateProfileParams(
      fullName: event.fullName,
      bio: event.bio,
      skills: event.skills,
      avatar: event.avatar,
      resume: event.resume,
    );

    final result = await _updateProfileUseCase(params);

    result.fold(
      (failure) => emit(
          state.copyWith(status: ProfileStatus.failure, error: failure.message)),
      (updatedUser) {
        _authViewModel.add(UserUpdated(updatedUser));
        emit(state.copyWith(
            status: ProfileStatus.success,
            successMessage: 'Profile updated successfully!'));
      },
    );
  }
}