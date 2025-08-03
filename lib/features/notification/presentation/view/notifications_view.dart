import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kamchaiyo/common/widgets/empty_state_display.dart';
import 'package:kamchaiyo/features/notification/presentation/view_model/notification_cubit.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = context.watch<NotificationCubit>().state.notifications;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (notifications.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: () {
                // You could add a confirmation dialog here
                context.read<NotificationCubit>().markAllAsRead();
              },
              tooltip: 'Mark all as read',
            )
        ],
      ),
      body: notifications.isEmpty
          ? const EmptyStateDisplay(
              icon: Icons.notifications_off_outlined,
              message: 'You have no notifications yet.',
            )
          : ListView.separated(
              itemCount: notifications.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.notifications),
                  ),
                  title: Text(notification.message),
                  subtitle: Text(
                    DateFormat.yMMMd().add_jm().format(notification.timestamp.toLocal()),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              },
            ),
    );
  }
}