import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kamchaiyo/app/service_locator/service_locator.dart';
import 'package:kamchaiyo/common/widgets/empty_state_display.dart';
import 'package:kamchaiyo/features/my_interviews/presentation/view_model/my_interviews_event.dart';
import 'package:kamchaiyo/features/my_interviews/presentation/view_model/my_interviews_state.dart';
import 'package:kamchaiyo/features/my_interviews/presentation/view_model/my_interviews_view_model.dart';
import 'package:kamchaiyo/features/notification/presentation/view/notifications_view.dart';
import 'package:kamchaiyo/features/notification/presentation/view_model/notification_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentMyInterviewsView extends StatefulWidget {
  const StudentMyInterviewsView({super.key});

  @override
  State<StudentMyInterviewsView> createState() =>
      _StudentMyInterviewsViewState();
}

class _StudentMyInterviewsViewState extends State<StudentMyInterviewsView> {
  @override
  void initState() {
    super.initState();
    context.read<MyInterviewsViewModel>().add(MyInterviewsFetched());
  }

  Future<void> _launchURL(BuildContext context, String? urlString) async {
    if (urlString == null || urlString.isEmpty) return;
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $urlString')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('My Interviews'),
          actions: [
            IconButton(
              icon: BlocBuilder<NotificationCubit, NotificationState>(
                builder: (context, state) {
                  return Badge(
                    label: Text(state.unreadCount.toString()),
                    isLabelVisible: state.unreadCount > 0,
                    child: const Icon(Icons.notifications_outlined),
                  );
                },
              ),
              onPressed: () {
                final notificationCubit = sl<NotificationCubit>();
                notificationCubit.markAllAsRead();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: notificationCubit,
                    child: const NotificationsView(),
                  ),
                ));
              },
            )
          ],
        ),
        body: BlocBuilder<MyInterviewsViewModel, MyInterviewsState>(
          builder: (context, state) {
            if (state.status == MyInterviewsStatus.loading &&
                state.interviews.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.interviews.isEmpty) {
              return const EmptyStateDisplay(
                icon: Icons.calendar_today_outlined,
                message: 'You have no interviews scheduled yet. Keep applying!',
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<MyInterviewsViewModel>()
                    .add(MyInterviewsFetched());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: state.interviews.length,
                itemBuilder: (context, index) {
                  final interview = state.interviews[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            interview.jobTitle,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('with ${interview.companyName}',
                              style: TextStyle(color: Colors.grey.shade600)),
                          const Divider(height: 24),
                          _buildInfoRow(Icons.calendar_month, 'Date',
                              DateFormat.yMMMMd().format(interview.date)),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                              Icons.access_time_filled, 'Time', interview.time),
                          const SizedBox(height: 12),
                          _buildLocationLink(context, interview.interviewType,
                              interview.locationOrLink)
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade700),
        const SizedBox(width: 8),
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
        Expanded(child: Text(value)),
      ],
    );
  }

  Widget _buildLocationLink(
      BuildContext context, String type, String locationOrLink) {
    final bool isLink = type == 'online';
    return Card(
      color: Colors.blue.shade50,
      elevation: 0,
      child: ListTile(
        leading: Icon(isLink ? Icons.videocam : Icons.location_on,
            color: Colors.blue.shade800),
        title: Text(locationOrLink,
            style: TextStyle(
                color: isLink ? Colors.blue.shade900 : Colors.black,
                decoration:
                    isLink ? TextDecoration.underline : TextDecoration.none)),
        dense: true,
        onTap: isLink ? () => _launchURL(context, locationOrLink) : null,
      ),
    );
  }
}