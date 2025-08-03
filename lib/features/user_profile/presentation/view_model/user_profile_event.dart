import 'package:equatable/equatable.dart';

abstract class UserProfileEvent extends Equatable {
  const UserProfileEvent();
  @override
  List<Object> get props => [];
}

class UserProfileFetched extends UserProfileEvent {
  final String userId;
  const UserProfileFetched(this.userId);
  @override
  List<Object> get props => [userId];
}