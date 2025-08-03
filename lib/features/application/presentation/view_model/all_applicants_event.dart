import 'package:equatable/equatable.dart';

abstract class AllApplicantsEvent extends Equatable {
  const AllApplicantsEvent();
  @override
  List<Object> get props => [];
}

class AllApplicantsDataFetched extends AllApplicantsEvent {}