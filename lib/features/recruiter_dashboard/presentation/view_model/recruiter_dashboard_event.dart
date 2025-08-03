
import 'package:equatable/equatable.dart';

abstract class RecruiterDashboardEvent extends Equatable {
  const RecruiterDashboardEvent();

  @override
  List<Object> get props => [];
}

class RecruiterStatsFetched extends RecruiterDashboardEvent {}