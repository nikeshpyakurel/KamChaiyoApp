import 'package:equatable/equatable.dart';

enum ChatRole { user, model }

class ChatMessageEntity extends Equatable {
  final String text;
  final ChatRole role;

  const ChatMessageEntity({required this.text, required this.role});

  @override
  List<Object?> get props => [text, role];
}