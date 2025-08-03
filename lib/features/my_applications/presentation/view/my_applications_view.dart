import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kamchaiyo/common/widgets/empty_state_display.dart';
import 'package:kamchaiyo/features/my_applications/presentation/view_model/my_applications_bloc.dart';

class MyApplicationsView extends StatefulWidget {
  const MyApplicationsView({super.key});

  @override
  State<MyApplicationsView> createState() => _MyApplicationsViewState();
}

class _MyApplicationsViewState extends State<MyApplicationsView> {
  @override
  void initState() {
    super.initState();
    context.read<MyApplicationsBloc>().add(MyApplicationsFetched());
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'accepted':
        return Colors.green.shade600;
      case 'rejected':
        return Colors.red.shade600;
      case 'pending':
      default:
        return Colors.orange.shade600;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'accepted':
        return Icons.check_circle_outline;
      case 'rejected':
        return Icons.highlight_off_outlined;
      case 'pending':
      default:
        return Icons.hourglass_empty_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Applications')),
      body: BlocBuilder<MyApplicationsBloc, MyApplicationsState>(
        builder: (context, state) {
          if (state.status == MyApplicationsStatus.loading &&
              state.applications.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.applications.isEmpty) {
            return const EmptyStateDisplay(
              icon: Icons.work_history_outlined,
              message: "You haven't applied to any jobs yet.",
              actionText: "Find Jobs",
              onActionPressed: null, // We'll hook this up in Sprint 3
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              context.read<MyApplicationsBloc>().add(MyApplicationsFetched());
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: state.applications.length,
              itemBuilder: (context, index) {
                final app = state.applications[index];
                return Card(
                  elevation: 2,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundImage: app.companyLogo != null
                              ? NetworkImage(app.companyLogo!)
                              : null,
                          child: app.companyLogo == null
                              ? Text(app.companyName[0])
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                app.jobTitle,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                app.companyName,
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Applied on: ${DateFormat.yMMMd().format(app.appliedDate)}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Chip(
                          avatar: Icon(_getStatusIcon(app.status),
                              color: Colors.white, size: 16),
                          label: Text(
                            app.status.toUpperCase(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10),
                          ),
                          backgroundColor: _getStatusColor(app.status),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                        )
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
  }
}