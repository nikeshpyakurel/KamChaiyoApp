import 'dart:async';
import 'package:kamchaiyo/core/network/api_endpoints.dart';
import 'package:kamchaiyo/features/chat/data/dto/message_dto.dart';
import 'package:kamchaiyo/features/chat/domain/entity/message_entity.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:kamchaiyo/features/notification/domain/entity/notification_entity.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? _socket;
  IO.Socket? get socket => _socket;

  final _newMessageController = StreamController<MessageEntity>.broadcast();
  Stream<MessageEntity> get onNewMessage => _newMessageController.stream;

  final _notificationController = StreamController<NotificationEntity>.broadcast();
  Stream<NotificationEntity> get onNotification => _notificationController.stream;

  void connect(String token) {
    if (_socket != null && _socket!.connected) {
      print("Socket already connected.");
      return;
    }
    disconnect(); 

    final String socketUrl = ApiEndpoints.baseUrl.replaceAll('/api/v1/', '');

    _socket = IO.io(socketUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'auth': {'token': token},
    });

    _socket!.on('messageReceived', _handleMessageReceived);
    _socket!.on('newApplication', (data) => _handleNotification(data, 'You have a new application.'));
    _socket!.on('applicationStatusUpdate', (data) => _handleNotification(data, 'Your application status was updated.'));
    _socket!.on('notification', (data) => _handleNotification(data, 'You have a new notification.'));

    _socket!.onConnect((_) => print('Socket connected: ${_socket!.id}'));
    _socket!.onDisconnect((_) => print('Socket disconnected'));
    _socket!.onConnectError((data) => print('Socket connection error: $data'));
    _socket!.onError((data) => print('Socket error: $data'));

    _socket!.connect();
  }

  void _handleMessageReceived(dynamic data) {
    try {
      print("Socket message received: $data");
      final messageDto = MessageDto.fromJson(data);
      final messageEntity = messageDto.toEntity();
      _newMessageController.add(messageEntity);
    } catch (e) {
      print("Error in SocketService parsing message: $e");
    }
  }

  void _handleNotification(dynamic data, String defaultMessage) {
    print("Socket notification received: $data");
    final message = data['message'] as String? ?? defaultMessage;
    _notificationController.add(NotificationEntity(message: message, timestamp: DateTime.now()));
  }

  void disconnect() {
    if (_socket != null) {
      _socket!.dispose();
      _socket = null;
    }
  }

  void dispose() {
    _newMessageController.close();
    _notificationController.close();
  }
}