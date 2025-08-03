import 'package:equatable/equatable.dart';
import 'package:kamchaiyo/features/application/domain/entity/application_entity.dart';

enum ApplicationStatus { initial, loading, success, failure }

class ApplicationState extends Equatable {
  final ApplicationStatus status;
  final List<ApplicationEntity> applicants;
  final String? error;
  final String? updatingApplicationId;

  const ApplicationState({
    this.status = ApplicationStatus.initial,
    this.applicants = const [],
    this.error,
    this.updatingApplicationId,
  });

  ApplicationState copyWith({
    ApplicationStatus? status,
    List<ApplicationEntity>? applicants,
    String? error,
    String? updatingApplicationId,
    bool clearError = false,
    bool clearUpdatingId = false,
  }) {
    return ApplicationState(
      status: status ?? this.status,
      applicants: applicants ?? this.applicants,
      error: clearError ? null : error,
      updatingApplicationId:
          clearUpdatingId ? null : updatingApplicationId ?? this.updatingApplicationId,
    );
  }

  @override
  List<Object?> get props => [status, applicants, error, updatingApplicationId];
}