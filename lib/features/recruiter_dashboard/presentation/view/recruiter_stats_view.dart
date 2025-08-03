import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kamchaiyo/common/widgets/empty_state_display.dart';
import 'package:kamchaiyo/common/widgets/section_header.dart';
import 'package:kamchaiyo/common/widgets/stat_card.dart';
import 'package:kamchaiyo/features/application/domain/entity/application_entity.dart';
import 'package:kamchaiyo/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:kamchaiyo/features/job/domain/entity/job_entity.dart';
import 'package:kamchaiyo/features/recruiter_dashboard/presentation/view_model/recruiter_dashboard_event.dart';
import 'package:kamchaiyo/features/recruiter_dashboard/presentation/view_model/recruiter_dashboard_state.dart';
import 'package:kamchaiyo/features/recruiter_dashboard/presentation/view_model/recruiter_dashboard_view_model.dart';

class RecruiterStatsView extends StatefulWidget {
  const RecruiterStatsView({super.key});

  @override
  State<RecruiterStatsView> createState() => _RecruiterStatsViewState();
}

class _RecruiterStatsViewState extends State<RecruiterStatsView> {
  @override
  void initState() {
    super.initState();
    context.read<RecruiterDashboardViewModel>().add(RecruiterStatsFetched());
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthViewModel>().state.user;
    final theme = Theme.of(context);

    return Scaffold(
      body: BlocBuilder<RecruiterDashboardViewModel, RecruiterDashboardState>(
        builder: (context, state) {
          if (state.status == RecruiterDashboardStatus.loading &&
              state.stats == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == RecruiterDashboardStatus.failure) {
            return Center(
                child: Text(state.error ?? 'Failed to load dashboard.'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              context
                  .read<RecruiterDashboardViewModel>()
                  .add(RecruiterStatsFetched());
            },
            child: ListView(
              padding: const EdgeInsets.only(bottom: 16), 
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back,',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(color: Colors.grey.shade600),
                      ),
                      Text(
                        user?.fullName ?? 'Recruiter',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                if (state.stats != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        const double spacing = 12.0;
                        final double cardWidth =
                            (constraints.maxWidth - (spacing * 2)) / 3;

                        return Wrap(
                          spacing: spacing,
                          runSpacing: spacing, 
                          children: [
                            _buildStatCard(
                              width: cardWidth,
                              icon: Icons.business,
                              label: 'Companies',
                              value: state.stats!.totalCompanies.toString(),
                              color: Colors.blue.shade700,
                            ),
                            _buildStatCard(
                              width: cardWidth,
                              icon: Icons.work,
                              label: 'Jobs Posted',
                              value: state.stats!.totalJobs.toString(),
                              color: Colors.green.shade700,
                            ),
                            _buildStatCard(
                              width: cardWidth,
                              icon: Icons.people,
                              label: 'Applicants',
                              value: state.stats!.totalApplicants.toString(),
                              color: Colors.orange.shade800,
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                const SectionHeader(title: 'Recent Activity'),
                if (state.recentJobs.isEmpty && state.recentApplicants.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 32.0),
                    child: EmptyStateDisplay(
                      icon: Icons.history_toggle_off,
                      message: 'No recent activity to show yet.',
                    ),
                  )
                else
                  ..._buildActivityList(context, state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard({
    required double width,
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return SizedBox(
      width: width,
      child: StatCard(
        icon: icon,
        label: label,
        value: value,
        color: color,
      ),
    );
  }

  List<Widget> _buildActivityList(
      BuildContext context, RecruiterDashboardState state) {
    final activities = [
      ...state.recentJobs
          .map((job) => (job.createdAt, _buildJobActivityTile(job))),
      ...state.recentApplicants
          .map((app) => (app.createdAt, _buildApplicantActivityTile(app))),
    ];

    activities.sort((a, b) => b.$1.compareTo(a.$1));

    return activities.take(5).map((e) => e.$2).toList();
  }

  Widget _buildJobActivityTile(JobEntity job) {
    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.work_history)),
      title: Text('New Job Posted: ${job.title}'),
      subtitle: Text(
          'At ${job.companyName} - ${DateFormat.yMMMd().format(job.createdAt.toLocal())}'),
    );
  }

  Widget _buildApplicantActivityTile(ApplicationEntity app) {
    return ListTile(
      leading: CircleAvatar(
          backgroundImage:
              app.applicant.avatar != null ? NetworkImage(app.applicant.avatar!) : null,
          child: app.applicant.avatar == null
              ? Text(app.applicant.fullName[0])
              : null),
      title: Text('New Applicant: ${app.applicant.fullName}'),
      subtitle: Text(
          'Applied for ${app.jobTitle} - ${DateFormat.yMMMd().format(app.createdAt.toLocal())}'),
    );
  }
}