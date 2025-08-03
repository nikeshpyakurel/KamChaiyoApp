import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamchaiyo/features/auth/domain/use_case/check_auth_status_usecase.dart';
import 'package:kamchaiyo/features/my_applications/domain/entity/my_application_entity.dart';
import 'package:kamchaiyo/features/my_applications/domain/use_case/get_my_applications_usecase.dart';

part 'my_applications_event.dart';
part 'my_applications_state.dart';

class MyApplicationsBloc
    extends Bloc<MyApplicationsEvent, MyApplicationsState> {
  final GetMyApplicationsUseCase _getMyApplicationsUseCase;

  MyApplicationsBloc({required GetMyApplicationsUseCase getMyApplicationsUseCase})
      : _getMyApplicationsUseCase = getMyApplicationsUseCase,
        super(const MyApplicationsState()) {
    on<MyApplicationsFetched>(_onMyApplicationsFetched);
  }

  Future<void> _onMyApplicationsFetched(
      MyApplicationsFetched event, Emitter<MyApplicationsState> emit) async {
    emit(state.copyWith(status: MyApplicationsStatus.loading));
    final result = await _getMyApplicationsUseCase(NoParams());
    result.fold(
      (failure) => emit(state.copyWith(
          status: MyApplicationsStatus.failure, error: failure.message)),
      (apps) => emit(state.copyWith(
          status: MyApplicationsStatus.success, applications: apps)),
    );
  }
}