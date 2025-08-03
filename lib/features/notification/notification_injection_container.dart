import 'package:get_it/get_it.dart';
import 'package:kamchaiyo/features/notification/presentation/view_model/notification_cubit.dart';

void initNotificationInjection(GetIt sl) {
  sl.registerSingleton<NotificationCubit>(
    NotificationCubit(socketService: sl()),
  );
}