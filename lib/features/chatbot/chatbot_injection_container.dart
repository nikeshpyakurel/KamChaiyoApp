import 'package:get_it/get_it.dart';
import 'package:kamchaiyo/features/chatbot/data/data_source/remote/chatbot_remote_data_source.dart';
import 'package:kamchaiyo/features/chatbot/data/repository/chatbot_repository_impl.dart';
import 'package:kamchaiyo/features/chatbot/domain/repository/chatbot_repository.dart';
import 'package:kamchaiyo/features/chatbot/domain/use_case/send_chat_query_usecase.dart';
import 'package:kamchaiyo/features/chatbot/presentation/view_model/chatbot_bloc.dart';

void initChatbotInjection(GetIt sl) {
  sl.registerFactory(() => ChatbotBloc(sendChatQueryUseCase: sl()));

  sl.registerLazySingleton(() => SendChatQueryUseCase(sl()));

  sl.registerLazySingleton<ChatbotRepository>(
      () => ChatbotRepositoryImpl(remoteDataSource: sl()));

  sl.registerLazySingleton<ChatbotRemoteDataSource>(
      () => ChatbotRemoteDataSourceImpl(sl()));
}