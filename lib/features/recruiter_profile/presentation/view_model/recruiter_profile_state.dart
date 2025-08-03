import 'package:equatable/equatable.dart';

enum RecruiterProfileStatus { initial, loading, success, failure }

class RecruiterProfileState extends Equatable {
  final RecruiterProfileStatus status;
  final String? error;

  const RecruiterProfileState({
    this.status = RecruiterProfileStatus.initial,
    this.error,
  });

  RecruiterProfileState copyWith({
    RecruiterProfileStatus? status,
    String? error,
    bool clearError = false,
  }) {
    return RecruiterProfileState(
      status: status ?? this.status,
      error: clearError ? null : error,
    );
  }

  @override
  List<Object?> get props => [status, error];
}