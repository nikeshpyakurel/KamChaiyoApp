import 'package:get_it/get_it.dart';
import 'package:kamchaiyo/core/network/socket_service.dart'; 
import 'package:kamchaiyo/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:kamchaiyo/features/chat/data/data_source/remote/chat_remote_data_source.dart';
import 'package:kamchaiyo/features/chat/data/repository/chat_repository_impl.dart';
import 'package:kamchaiyo/features/chat/domain/repository/chat_repository.dart';
import 'package:kamchaiyo/features/chat/domain/use_case/get_messages_usecase.dart';
import 'package:kamchaiyo/features/chat/domain/use_case/get_my_chats_usecase.dart';
import 'package:kamchaiyo/features/chat/domain/use_case/send_message_usecase.dart';
import 'package:kamchaiyo/features/chat/presentation/view_model/chats_list_view_model/chats_list_view_model.dart';
import 'package:kamchaiyo/features/chat/presentation/view_model/conversation_view_model/conversation_view_model.dart';

void initChatInjection(GetIt sl) {
  
  sl.registerLazySingleton<SocketService>(() => SocketService());

  
  sl.registerFactory(() => ChatsListViewModel(getMyChatsUseCase: sl()));
  sl.registerFactory(() => ConversationViewModel(
        getMessagesUseCase: sl(),
        sendMessageUseCase: sl(),
      ));

  
  sl.registerLazySingleton(() => GetMyChatsUseCase(sl()));
  sl.registerLazySingleton(() => GetMessagesUseCase(sl()));
  sl.registerLazySingleton(() => SendMessageUseCase(sl()));

  
  sl.registerLazySingleton<ChatRepository>(
      () => ChatRepositoryImpl(remoteDataSource: sl(), authViewModel: sl<AuthViewModel>()));

  sl.registerLazySingleton<ChatRemoteDataSource>(
      () => ChatRemoteDataSourceImpl(sl()));
}