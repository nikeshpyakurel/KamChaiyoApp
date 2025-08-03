import 'package:equatable/equatable.dart';

class UserChatEntity extends Equatable {
  final String id;
  final String fullName;
  final String? avatar;
  const UserChatEntity({required this.id, required this.fullName, this.avatar});
  @override
  List<Object?> get props => [id, fullName, avatar];
}