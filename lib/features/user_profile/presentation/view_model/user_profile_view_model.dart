import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamchaiyo/features/user_profile/domain/use_case/get_user_profile_usecase.dart';
import 'package:kamchaiyo/features/user_profile/presentation/view_model/user_profile_event.dart';
import 'package:kamchaiyo/features/user_profile/presentation/view_model/user_profile_state.dart';

class UserProfileViewModel extends Bloc<UserProfileEvent, UserProfileState> {
  final GetUserProfileUseCase _getUserProfileUseCase;

  UserProfileViewModel({required GetUserProfileUseCase getUserProfileUseCase})
      : _getUserProfileUseCase = getUserProfileUseCase,
        super(const UserProfileState()) {
    on<UserProfileFetched>(_onUserProfileFetched);
  }

  Future<void> _onUserProfileFetched(
      UserProfileFetched event, Emitter<UserProfileState> emit) async {
    emit(state.copyWith(status: UserProfileStatus.loading));
    final result = await _getUserProfileUseCase(event.userId);
    result.fold(
      (failure) =>
          emit(state.copyWith(status: UserProfileStatus.failure, error: failure.message)),
      (userProfile) => emit(
          state.copyWith(status: UserProfileStatus.success, userProfile: userProfile)),
    );
  }
}