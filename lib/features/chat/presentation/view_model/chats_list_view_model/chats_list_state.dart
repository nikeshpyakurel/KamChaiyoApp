import 'package:equatable/equatable.dart';
import 'package:kamchaiyo/features/chat/domain/entity/chat_entity.dart';

enum ChatsListStatus { initial, loading, success, failure }

class ChatsListState extends Equatable {
  final ChatsListStatus status;
  final List<ChatEntity> chats;
  final String? error;
  final String searchQuery;

  const ChatsListState({
    this.status = ChatsListStatus.initial,
    this.chats = const [],
    this.error,
    this.searchQuery = '',
  });

  List<ChatEntity> get filteredChats {
    if (searchQuery.isEmpty) {
      return chats;
    }
    return chats
        .where((chat) => chat.otherUser.fullName
            .toLowerCase()
            .contains(searchQuery.toLowerCase()))
        .toList();
  }

  ChatsListState copyWith({
    ChatsListStatus? status,
    List<ChatEntity>? chats,
    String? error,
    String? searchQuery,
    bool clearError = false,
  }) {
    return ChatsListState(
      status: status ?? this.status,
      chats: chats ?? this.chats,
      error: clearError ? null : error,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [status, chats, error, searchQuery];
}