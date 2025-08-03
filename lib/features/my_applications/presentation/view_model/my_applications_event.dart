part of 'my_applications_bloc.dart';

abstract class MyApplicationsEvent extends Equatable {
  const MyApplicationsEvent();

  @override
  List<Object> get props => [];
}

class MyApplicationsFetched extends MyApplicationsEvent {}