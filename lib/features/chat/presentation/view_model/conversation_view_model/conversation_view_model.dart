import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamchaiyo/app/service_locator/service_locator.dart';
import 'package:kamchaiyo/core/network/socket_service.dart';
import 'package:kamchaiyo/features/chat/domain/entity/message_entity.dart';
import 'package:kamchaiyo/features/chat/domain/use_case/get_messages_usecase.dart';
import 'package:kamchaiyo/features/chat/domain/use_case/send_message_usecase.dart';
import 'package:kamchaiyo/features/chat/presentation/view_model/conversation_view_model/conversation_event.dart';
import 'package:kamchaiyo/features/chat/presentation/view_model/conversation_view_model/conversation_state.dart';

class ConversationViewModel extends Bloc<ConversationEvent, ConversationState> {
  final GetMessagesUseCase _getMessagesUseCase;
  final SendMessageUseCase _sendMessageUseCase;
  final SocketService _socketService = sl<SocketService>();
  StreamSubscription? _newMessageSubscription;
  late final String _chatId;

  ConversationViewModel({
    required GetMessagesUseCase getMessagesUseCase,
    required SendMessageUseCase sendMessageUseCase,
  })  : _getMessagesUseCase = getMessagesUseCase,
        _sendMessageUseCase = sendMessageUseCase,
        super(const ConversationState()) {
    on<ConversationOpened>(_onConversationOpened);
    on<MessageSent>(_onMessageSent);
    on<MessageReceived>(_onMessageReceived);
    on<TypingStarted>(_onTypingStarted);
    on<TypingStopped>(_onTypingStopped);
    on<TypingStatusReceived>(_onTypingStatusReceived);
  }

  void _socketMessageListener(MessageEntity message) {
    if (!isClosed && message.chatId == _chatId) {
      add(MessageReceived(message));
    }
  }

  void _socketTypingListener(dynamic data) {
    if (!isClosed && data['chatId'] == _chatId) {
      add(TypingStatusReceived(data['isTyping'] as bool));
    }
  }

  Future<void> _onConversationOpened(
      ConversationOpened event, Emitter<ConversationState> emit) async {
    _chatId = event.chatId;
    emit(state.copyWith(status: ConversationStatus.loading));

    _newMessageSubscription = _socketService.onNewMessage.listen(_socketMessageListener);
    _socketService.socket?.on('typing', _socketTypingListener);

    final result = await _getMessagesUseCase(event.chatId);
    result.fold(
      (failure) => emit(state.copyWith(status: ConversationStatus.failure, error: failure.message)),
      (messages) {
        messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        emit(state.copyWith(status: ConversationStatus.success, messages: messages));
      },
    );
  }

  Future<void> _onMessageSent(MessageSent event, Emitter<ConversationState> emit) async {
    final params = SendMessageParams(chatId: _chatId, content: event.content);
    await _sendMessageUseCase(params);
  }

  void _onMessageReceived(MessageReceived event, Emitter<ConversationState> emit) {
    final updatedMessages = List<MessageEntity>.from(state.messages)..add(event.message);
    emit(state.copyWith(messages: updatedMessages, status: ConversationStatus.success, isTyping: false));
  }

  void _onTypingStarted(TypingStarted event, Emitter<ConversationState> emit) {
    _socketService.socket?.emit('typing', {'chatId': _chatId, 'isTyping': true});
  }

  void _onTypingStopped(TypingStopped event, Emitter<ConversationState> emit) {
    _socketService.socket?.emit('typing', {'chatId': _chatId, 'isTyping': false});
  }

  void _onTypingStatusReceived(TypingStatusReceived event, Emitter<ConversationState> emit) {
    emit(state.copyWith(isTyping: event.isTyping));
  }

  @override
  Future<void> close() {
    _socketService.socket?.emit('typing', {'chatId': _chatId, 'isTyping': false});
    _newMessageSubscription?.cancel();
    _socketService.socket?.off('typing', _socketTypingListener);
    return super.close();
  }
}