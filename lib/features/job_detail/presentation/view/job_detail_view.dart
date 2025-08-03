import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kamchaiyo/app/service_locator/service_locator.dart';
import 'package:kamchaiyo/common/snake_bar.dart';
import 'package:kamchaiyo/features/home/presentation/view_model/home_navigation/home_navigation_cubit.dart';
import 'package:kamchaiyo/features/job_detail/presentation/view_model/job_detail_bloc.dart';
import 'package:kamchaiyo/features/my_applications/presentation/view_model/my_applications_bloc.dart';

class JobDetailView extends StatelessWidget {
  final String jobId;
  const JobDetailView({super.key, required this.jobId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<JobDetailBloc>()..add(JobDetailFetched(jobId)),
      child: BlocListener<JobDetailBloc, JobDetailState>(
        listener: (context, state) {
          if (state.applyStatus == JobApplyStatus.success) {
            showSnackBar(
                context: context,
                message: 'Successfully applied for the job!',
                color: Colors.green);
            context.read<MyApplicationsBloc>().add(MyApplicationsFetched());
            context.read<HomeNavigationCubit>().changeTab(1);
            Navigator.of(context).pop();
          }
          if (state.applyStatus == JobApplyStatus.failure) {
            showSnackBar(
                context: context,
                message: state.applyError ?? 'Application failed.',
                color: Colors.red);
          }
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('Job Details')),
          body: BlocBuilder<JobDetailBloc, JobDetailState>(
            builder: (context, state) {
              if (state.status == JobDetailStatus.loading ||
                  state.status == JobDetailStatus.initial) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.status == JobDetailStatus.failure || state.job == null) {
                return Center(child: Text(state.error ?? 'Could not load job details.'));
              }

              final job = state.job!;

              return Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16.0),
                      children: [
                        _buildHeader(context, job),
                        const SizedBox(height: 16),
                        _buildInfoTabs(context, job),
                        const SizedBox(height: 16),
                        _buildSection(
                          context,
                          title: 'Job Description',
                          content: Text(job.description),
                        ),
                        const SizedBox(height: 16),
                        _buildSection(
                          context,
                          title: 'Requirements',
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: job.requirements
                                .map((req) => Padding(
                                      padding: const EdgeInsets.only(bottom: 4.0),
                                      child: Text('• $req'),
                                    ))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildApplyButton(context, state),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, job) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage:
              job.companyLogo != null ? NetworkImage(job.companyLogo!) : null,
          child:
              job.companyLogo == null ? Text(job.companyName[0]) : null,
        ),
        const SizedBox(height: 12),
        Text(job.title, style: Theme.of(context).textTheme.headlineSmall),
        Text('${job.companyName} • ${job.location}',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.grey.shade600)),
      ],
    );
  }

  Widget _buildInfoTabs(BuildContext context, job) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _infoChip(context, Icons.work_outline, job.jobType),
        _infoChip(context, Icons.stairs_outlined, job.experienceLevel),
        _infoChip(
            context,
            Icons.attach_money,
            NumberFormat.compactSimpleCurrency(locale: 'en_IN')
                .format(job.salary)),
      ],
    );
  }

  Widget _infoChip(BuildContext context, IconData icon, String label) {
    return Chip(
      avatar: Icon(icon, size: 16, color: Theme.of(context).primaryColor),
      label: Text(label),
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
    );
  }

  Widget _buildSection(BuildContext context,
      {required String title, required Widget content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const Divider(height: 16),
        content,
      ],
    );
  }

  Widget _buildApplyButton(BuildContext context, JobDetailState state) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: state.applyStatus == JobApplyStatus.loading
                ? null
                : () => context.read<JobDetailBloc>().add(JobApplyButtonPressed()),
            child: state.applyStatus == JobApplyStatus.loading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                  )
                : const Text('Apply Now'),
          ),
        ),
      ),
    );
  }
}