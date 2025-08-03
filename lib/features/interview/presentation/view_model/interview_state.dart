
import 'package:equatable/equatable.dart';

enum InterviewScheduleStatus { initial, loading, success, failure }

class InterviewState extends Equatable {
  final InterviewScheduleStatus status;
  final String? error;
  final String? successMessage;

  const InterviewState({
    this.status = InterviewScheduleStatus.initial,
    this.error,
    this.successMessage,
  });

  InterviewState copyWith({
    InterviewScheduleStatus? status,
    String? error,
    String? successMessage,
  }) {
    return InterviewState(
      status: status ?? this.status,
      error: error,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [status, error, successMessage];
}