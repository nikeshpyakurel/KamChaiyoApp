import 'package:equatable/equatable.dart';

class InterviewEntity extends Equatable {
  final String id;
  const InterviewEntity({required this.id});
  @override
  List<Object> get props => [id];
}