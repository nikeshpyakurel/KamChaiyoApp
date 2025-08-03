
import 'package:equatable/equatable.dart';
import 'package:kamchaiyo/features/my_interviews/domain/entity/interview_details_entity.dart';

enum MyInterviewsStatus { initial, loading, success, failure }

class MyInterviewsState extends Equatable {
  final MyInterviewsStatus status;
  final List<InterviewDetailsEntity> interviews;
  final String? error;

  const MyInterviewsState({
    this.status = MyInterviewsStatus.initial,
    this.interviews = const [],
    this.error,
  });

  MyInterviewsState copyWith({
    MyInterviewsStatus? status,
    List<InterviewDetailsEntity>? interviews,
    String? error,
  }) {
    return MyInterviewsState(
      status: status ?? this.status,
      interviews: interviews ?? this.interviews,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, interviews, error];
}