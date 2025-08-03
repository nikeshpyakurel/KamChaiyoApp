import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String message;
  final DateTime timestamp;

  const NotificationEntity({
    required this.message,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [message, timestamp];
}