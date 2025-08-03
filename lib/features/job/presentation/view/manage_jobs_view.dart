import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamchaiyo/common/snake_bar.dart';
import 'package:kamchaiyo/features/job/presentation/view/add_edit_job_view.dart';
import 'package:kamchaiyo/features/job/presentation/view_model/job_event.dart';
import 'package:kamchaiyo/features/job/presentation/view_model/job_state.dart';
import 'package:kamchaiyo/features/job/presentation/view_model/job_view_model.dart';

class ManageJobsView extends StatelessWidget {
  const ManageJobsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<JobViewModel, JobState>(
        listener: (context, state) {
          if (state.message != null && state.message!.isNotEmpty) {
            showSnackBar(
                context: context, message: state.message!, color: Colors.green);
          }
          if (state.error != null && state.error!.isNotEmpty) {
            showSnackBar(
                context: context, message: state.error!, color: Colors.red);
          }
        },
        builder: (context, state) {
          if (state.status == JobStatus.loading && state.jobs.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.jobs.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'You have not posted any jobs yet.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text('Tap to Refresh'),
                      onPressed: (){
                        context.read<JobViewModel>().add(MyJobsAndCompaniesFetched());
                      },
                    )
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<JobViewModel>().add(MyJobsAndCompaniesFetched());
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: state.jobs.length,
              itemBuilder: (context, index) {
                final job = state.jobs[index];
                return Card(
                  elevation: 3,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    leading: CircleAvatar(
                      backgroundImage: job.companyLogo != null
                          ? NetworkImage(job.companyLogo!)
                          : null,
                      child: job.companyLogo == null
                          ? Text(job.companyName[0])
                          : null,
                    ),
                    title: Text(job.title,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${job.companyName} • ${job.location}'),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: context.read<JobViewModel>(),
                              child: AddEditJobView(job: job),
                            ),
                          ));
                        } else if (value == 'delete') {
                           _showDeleteConfirmation(context, job.id, job.title);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'edit', child: Text('Edit')),
                        const PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete', style: TextStyle(color: Colors.red))),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'job-fab',
        onPressed: () {
           if (context.read<JobViewModel>().state.myCompanies.isEmpty) {
            showSnackBar(
              context: context,
              message: 'Please create a company before posting a job.',
              color: Colors.orange,
            );
            return;
          }
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<JobViewModel>(),
              child: const AddEditJobView(),
            ),
          ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String jobId, String jobTitle) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Are you sure you want to delete the job posting for "$jobTitle"?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
              onPressed: () {
                context.read<JobViewModel>().add(JobDeleted(jobId));
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }
}