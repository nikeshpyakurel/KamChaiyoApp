import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamchaiyo/app/service_locator/service_locator.dart';
import 'package:kamchaiyo/features/application/presentation/view/job_applicants_view.dart';
import 'package:kamchaiyo/features/application/presentation/view_model/all_applicants_event.dart';
import 'package:kamchaiyo/features/application/presentation/view_model/all_applicants_state.dart';
import 'package:kamchaiyo/features/application/presentation/view_model/all_applicants_view_model.dart';

class RecruiterAllApplicationsView extends StatelessWidget {
  const RecruiterAllApplicationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AllApplicantsViewModel>()..add(AllApplicantsDataFetched()),
      child: Scaffold(
        body: BlocBuilder<AllApplicantsViewModel, AllApplicantsState>(
          builder: (context, state) {
            if (state.status == AllApplicantsStatus.loading && state.jobs.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == AllApplicantsStatus.failure) {
              return Center(child: Text(state.error ?? 'Could not load data.'));
            }

            if (state.jobs.isEmpty) {
              return const Center(
                child: Text(
                  'You have not posted any jobs yet.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<AllApplicantsViewModel>().add(AllApplicantsDataFetched());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: state.jobs.length,
                itemBuilder: (context, index) {
                  final job = state.jobs[index];
                  final count = state.applicantCounts[job.id] ?? 0;

                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => JobApplicantsView(
                            jobId: job.id,
                            jobTitle: job.title,
                          ),
                        ));
                      },
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
                      subtitle: Text(job.companyName),
                      trailing: Chip(
                        avatar: const Icon(Icons.people, size: 16),
                        label: Text(
                          count.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}