import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kamchaiyo/common/widgets/empty_state_display.dart';
import 'package:kamchaiyo/features/home/presentation/view_model/job_feed/job_feed_bloc.dart';
import 'package:kamchaiyo/features/notification/presentation/view/notifications_view.dart';
import 'package:kamchaiyo/features/notification/presentation/view_model/notification_cubit.dart';

class JobFeedView extends StatefulWidget {
  const JobFeedView({super.key});

  @override
  State<JobFeedView> createState() => _JobFeedViewState();
}

class _JobFeedViewState extends State<JobFeedView> {
  @override
  void initState() {
    super.initState();
    context.read<JobFeedBloc>().add(JobFeedFetched());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommended For You'),
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
              // Mark as read when opening the notifications screen
              context.read<NotificationCubit>().markAllAsRead();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<NotificationCubit>(),
                    child: const NotificationsView(),
                  ),
                ),
              );
            },
          )
        ],
      ),
      
      body: BlocBuilder<JobFeedBloc, JobFeedState>(
        builder: (context, state) {
          if (state.status == JobFeedStatus.loading &&
              state.recommendations.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == JobFeedStatus.failure) {
            return Center(child: Text(state.error ?? 'Failed to load jobs.'));
          }

          if (state.recommendations.isEmpty) {
            return const EmptyStateDisplay(
              icon: Icons.work_off_outlined,
              message:
                  'No job recommendations found. Update your profile with skills to get better matches!',
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<JobFeedBloc>().add(JobFeedFetched());
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: state.recommendations.length,
              itemBuilder: (context, index) {
                final job = state.recommendations[index];
                return Card(
                  elevation: 2,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundImage: job.companyLogo != null
                          ? NetworkImage(job.companyLogo!)
                          : null,
                      child: job.companyLogo == null
                          ? Text(job.companyName[0].toUpperCase())
                          : null,
                    ),
                    title: Text(job.title,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('${job.companyName} • ${job.location}'),
                        const SizedBox(height: 8),
                        Text(
                          NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0)
                              .format(job.salary),
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}