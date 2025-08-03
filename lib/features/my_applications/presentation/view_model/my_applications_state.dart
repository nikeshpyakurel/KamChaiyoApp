part of 'my_applications_bloc.dart';

enum MyApplicationsStatus { initial, loading, success, failure }

class MyApplicationsState extends Equatable {
  final MyApplicationsStatus status;
  final List<MyApplicationEntity> applications;
  final String? error;

  const MyApplicationsState({
    this.status = MyApplicationsStatus.initial,
    this.applications = const [],
    this.error,
  });

  MyApplicationsState copyWith({
    MyApplicationsStatus? status,
    List<MyApplicationEntity>? applications,
    String? error,
  }) {
    return MyApplicationsState(
      status: status ?? this.status,
      applications: applications ?? this.applications,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, applications, error];
}