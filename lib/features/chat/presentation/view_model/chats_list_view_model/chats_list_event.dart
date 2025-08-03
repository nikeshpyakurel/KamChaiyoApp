import 'package:equatable/equatable.dart';
import 'package:kamchaiyo/features/chat/domain/entity/message_entity.dart';

abstract class ChatsListEvent extends Equatable {
  const ChatsListEvent();
  @override
  List<Object> get props => [];
}

class ChatsListFetched extends ChatsListEvent {}

class ChatsListSearched extends ChatsListEvent {
  final String query;

  const ChatsListSearched(this.query);

  @override
  List<Object> get props => [query];
}

class NewMessageReceived extends ChatsListEvent {
  final MessageEntity message;

  const NewMessageReceived(this.message);

  @override
  List<Object> get props => [message];
}