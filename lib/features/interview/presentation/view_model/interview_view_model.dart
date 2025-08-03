import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamchaiyo/features/interview/domain/use_case/schedule_interview_usecase.dart';
import 'package:kamchaiyo/features/interview/presentation/view_model/interview_event.dart';
import 'package:kamchaiyo/features/interview/presentation/view_model/interview_state.dart';

class InterviewViewModel extends Bloc<InterviewEvent, InterviewState> {
  final ScheduleInterviewUseCase _scheduleInterviewUseCase;

  InterviewViewModel({required ScheduleInterviewUseCase scheduleInterviewUseCase})
      : _scheduleInterviewUseCase = scheduleInterviewUseCase,
        super(const InterviewState()) {
    on<InterviewScheduled>(_onInterviewScheduled);
  }

  Future<void> _onInterviewScheduled(
      InterviewScheduled event, Emitter<InterviewState> emit) async {
    emit(state.copyWith(status: InterviewScheduleStatus.loading));
    final result = await _scheduleInterviewUseCase(event.params);
    result.fold(
      (failure) => emit(state.copyWith(
          status: InterviewScheduleStatus.failure, error: failure.message)),
      (_) => emit(state.copyWith(
          status: InterviewScheduleStatus.success,
          successMessage: 'Interview scheduled successfully!')),
    );
  }
}