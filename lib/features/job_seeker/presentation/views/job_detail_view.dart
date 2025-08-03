import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamchaiyo/features/job/domain/entity/job_entity.dart';
import 'package:kamchaiyo/features/job_seeker/presentation/view_models/job_search/job_search_bloc.dart';

class JobDetailView extends StatelessWidget {
  final JobEntity job;
  const JobDetailView({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(job.companyName),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, theme),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoChips(),
                  const SizedBox(height: 24),
                  Text('Job Description', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(job.description, style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 24),
                  Text('Requirements', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...job.requirements.map((req) => ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.check_circle_outline, size: 20, color: Colors.green),
                        title: Text(req),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildApplyButton(context),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Container(
      width: double.infinity,
      color: theme.scaffoldBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage:
                job.companyLogo != null ? NetworkImage(job.companyLogo!) : null,
            child: job.companyLogo == null ? Text(job.companyName[0], style: const TextStyle(fontSize: 32),) : null,
          ),
          const SizedBox(height: 16),
          Text(job.title,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(job.location, style: theme.textTheme.titleMedium),
        ],
      ),
    );
  }

  Widget _buildInfoChips() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: [
        Chip(
          avatar: const Icon(Icons.work_outline),
          label: Text(job.jobType),
        ),
        Chip(
          avatar: const Icon(Icons.stairs_outlined),
          label: Text(job.experienceLevel),
        ),
        Chip(
          avatar: const Icon(Icons.attach_money_outlined),
          label: Text('NPR ${job.salary}/mo'),
          backgroundColor: Colors.green.shade50,
        ),
      ],
    );
  }

  Widget _buildApplyButton(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<JobSearchBloc, JobSearchState>(
          builder: (context, state) {
            final isApplying = state.status == JobSearchStatus.applying && state.applyingJobId == job.id;
            
            final hasApplied = state.appliedJobIds.contains(job.id);

            if (isApplying) {
              return const Center(child: CircularProgressIndicator());
            }

            return ElevatedButton(
              onPressed: hasApplied ? null : () {
                context.read<JobSearchBloc>().add(JobApplied(job.id));
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              child: Text(hasApplied ? 'Applied' : 'Apply Now'),
            );
          },
        ),
      ),
    );
  }
}