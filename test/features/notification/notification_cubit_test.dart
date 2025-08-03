import 'package:flutter_test/flutter_test.dart';
import 'package:kamchaiyo/features/notification/presentation/view_model/notification_cubit.dart';
import 'package:kamchaiyo/core/network/socket_service.dart';
import 'package:mocktail/mocktail.dart';

class MockSocketService extends Mock implements SocketService {}

void main() {
  group('NotificationCubit', () {
    late NotificationCubit notificationCubit;
    late MockSocketService mockSocketService;

    setUp(() {
      mockSocketService = MockSocketService();
      when(() => mockSocketService.onNotification).thenAnswer(
        (_) => Stream.empty(),
      );
      notificationCubit = NotificationCubit(socketService: mockSocketService);
    });

    tearDown(() {
      notificationCubit.close();
    });

    test('initial state should have empty notifications and zero unread count', () {
      expect(notificationCubit.state.notifications, isEmpty);
      expect(notificationCubit.state.unreadCount, equals(0));
    });
  });
} 