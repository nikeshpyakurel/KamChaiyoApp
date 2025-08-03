import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamchaiyo/app/service_locator/service_locator.dart';
import 'package:kamchaiyo/core/network/socket_service.dart';
import 'package:kamchaiyo/features/chat/domain/entity/chat_entity.dart'; 
import 'package:kamchaiyo/features/auth/domain/use_case/check_auth_status_usecase.dart'; 
import 'package:kamchaiyo/features/chat/domain/use_case/get_my_chats_usecase.dart';
import 'package:kamchaiyo/features/chat/presentation/view_model/chats_list_view_model/chats_list_event.dart';
import 'package:kamchaiyo/features/chat/presentation/view_model/chats_list_view_model/chats_list_state.dart';

class ChatsListViewModel extends Bloc<ChatsListEvent, ChatsListState> {
  final GetMyChatsUseCase _getMyChatsUseCase;
  final SocketService _socketService = sl<SocketService>();
  StreamSubscription? _newMessageSubscription;

  ChatsListViewModel({required GetMyChatsUseCase getMyChatsUseCase})
      : _getMyChatsUseCase = getMyChatsUseCase,
        super(const ChatsListState()) {
    on<ChatsListFetched>(_onChatsListFetched);
    on<ChatsListSearched>(_onChatsListSearched);

 
    _newMessageSubscription = _socketService.onNewMessage.listen((_) {
      if (!isClosed) {
        add(ChatsListFetched());
      }
    });
  }

  Future<void> _onChatsListFetched(
      ChatsListFetched event, Emitter<ChatsListState> emit) async {
    // Show loading only on the first fetch
    if (state.status == ChatsListStatus.initial) {
      emit(state.copyWith(status: ChatsListStatus.loading));
    }
    await _fetchData(emit);
  }

  // FIX: Implement the handler for search events
  void _onChatsListSearched(
      ChatsListSearched event, Emitter<ChatsListState> emit) {
    emit(state.copyWith(searchQuery: event.query));
  }

  Future<void> _fetchData(Emitter<ChatsListState> emit) async {
    final result = await _getMyChatsUseCase(NoParams());
    result.fold(
      (failure) => emit(
          state.copyWith(status: ChatsListStatus.failure, error: failure.message)),
      (chats) {
        // Sort chats to show the most recent ones first
        chats.sort((a, b) {
          final aTime = a.latestMessage?.createdAt;
          final bTime = b.latestMessage?.createdAt;
          if (aTime == null && bTime == null) return 0;
          if (aTime == null) return 1;
          if (bTime == null) return -1;
          return bTime.compareTo(aTime);
        });
        emit(state.copyWith(status: ChatsListStatus.success, chats: chats));
      },
    );
  }

  @override
  Future<void> close() {
    _newMessageSubscription?.cancel();
    return super.close();
  }
}