import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamchaiyo/features/auth/domain/use_case/check_auth_status_usecase.dart';
import 'package:kamchaiyo/features/my_interviews/domain/use_case/get_my_interviews_usecase.dart';
import 'package:kamchaiyo/features/my_interviews/presentation/view_model/my_interviews_event.dart';
import 'package:kamchaiyo/features/my_interviews/presentation/view_model/my_interviews_state.dart';


class MyInterviewsViewModel extends Bloc<MyInterviewsEvent, MyInterviewsState> {
  final GetMyInterviewsUseCase _getMyInterviewsUseCase;

  MyInterviewsViewModel({required GetMyInterviewsUseCase getMyInterviewsUseCase})
      : _getMyInterviewsUseCase = getMyInterviewsUseCase,
        super(const MyInterviewsState()) {
    on<MyInterviewsFetched>(_onMyInterviewsFetched);
  }

  Future<void> _onMyInterviewsFetched(
      MyInterviewsFetched event, Emitter<MyInterviewsState> emit) async {
    emit(state.copyWith(status: MyInterviewsStatus.loading));
    final result = await _getMyInterviewsUseCase(NoParams());
    result.fold(
      (failure) =>
          emit(state.copyWith(status: MyInterviewsStatus.failure, error: failure.message)),
      (interviews) => emit(
          state.copyWith(status: MyInterviewsStatus.success, interviews: interviews)),
    );
  }
}