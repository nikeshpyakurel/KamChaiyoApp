import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamchaiyo/core/network/socket_service.dart';
import 'package:kamchaiyo/features/notification/domain/entity/notification_entity.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final SocketService _socketService;
  StreamSubscription? _notificationSubscription;

  NotificationCubit({required SocketService socketService})
      : _socketService = socketService,
        super(const NotificationState()) {
    _listenForNotifications();
  }

  void _listenForNotifications() {
    _notificationSubscription =
        _socketService.onNotification.listen((notification) {
      final newNotifications = List<NotificationEntity>.from(state.notifications)
        ..insert(0, notification); 
      emit(state.copyWith(
        notifications: newNotifications,
        unreadCount: state.unreadCount + 1,
      ));
    });
  }

  void markAllAsRead() {
    emit(state.copyWith(unreadCount: 0));
  }

  @override
  Future<void> close() {
    _notificationSubscription?.cancel();
    return super.close();
  }
}