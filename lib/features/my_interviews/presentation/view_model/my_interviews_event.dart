
import 'package:equatable/equatable.dart';

abstract class MyInterviewsEvent extends Equatable {
  const MyInterviewsEvent();
  @override
  List<Object> get props => [];
}

class MyInterviewsFetched extends MyInterviewsEvent {}