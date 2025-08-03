import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamchaiyo/app/service_locator/service_locator.dart';
import 'package:kamchaiyo/features/application/presentation/view_model/application_event.dart';
import 'package:kamchaiyo/features/application/presentation/view_model/application_state.dart';
import 'package:kamchaiyo/features/application/presentation/view_model/application_view_model.dart';
import 'package:kamchaiyo/features/interview/presentation/view/schedule_interview_view.dart';
import 'package:kamchaiyo/features/interview/presentation/view_model/interview_view_model.dart';
import 'package:kamchaiyo/features/user_profile/presentation/view/user_profile_view.dart';

class JobApplicantsView extends StatelessWidget {
  final String jobId;
  final String jobTitle;
  const JobApplicantsView({
    super.key,
    required this.jobId,
    required this.jobTitle,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<ApplicationViewModel>()..add(ApplicantsFetched(jobId)),
      child: Scaffold(
        appBar: AppBar(title: Text('Applicants for "$jobTitle"')),
        body: BlocBuilder<ApplicationViewModel, ApplicationState>(
          builder: (context, state) {
            if (state.status == ApplicationStatus.loading &&
                state.applicants.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.applicants.isEmpty) {
              return const Center(
                child: Text('No one has applied for this job yet.'),
              );
            }

            return ListView.builder(
              itemCount: state.applicants.length,
              itemBuilder: (context, index) {
                final application = state.applicants[index];
                final applicant = application.applicant;
                final isUpdating =
                    state.updatingApplicationId == application.id;

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  UserProfileView(userId: applicant.id),
                            ),
                          ),
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundImage: applicant.avatar != null
                                ? NetworkImage(applicant.avatar!)
                                : null,
                            child: applicant.avatar == null
                                ? Text(applicant.fullName[0].toUpperCase())
                                : null,
                          ),
                          title: Text(
                            applicant.fullName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(applicant.email),
                          trailing: Chip(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            label: Text(
                              application.status,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            backgroundColor: _getStatusColor(
                              application.status,
                            ),
                          ),
                        ),
                        const Divider(height: 20, indent: 16, endIndent: 16),
                        isUpdating
                            ? const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                  ),
                                ),
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton.icon(
                                    icon:
                                        const Icon(Icons.check_circle_outline),
                                    label: const Text('Accept'),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.green.shade700,
                                    ),
                                    onPressed:
                                        application.status == 'accepted'
                                            ? null
                                            : () => context
                                                .read<ApplicationViewModel>()
                                                .add(
                                                  ApplicationStatusUpdated(
                                                    application.id,
                                                    'accepted',
                                                  ),
                                                ),
                                  ),
                                  TextButton.icon(
                                    icon: const Icon(Icons.cancel_outlined),
                                    label: const Text('Reject'),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.red.shade700,
                                    ),
                                    onPressed:
                                        application.status == 'rejected'
                                            ? null
                                            : () => context
                                                .read<ApplicationViewModel>()
                                                .add(
                                                  ApplicationStatusUpdated(
                                                    application.id,
                                                    'rejected',
                                                  ),
                                                ),
                                  ),
                                  ElevatedButton.icon(
                                    icon: const Icon(
                                      Icons.calendar_month,
                                      size: 18,
                                    ),
                                    label: const Text('Schedule'),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      visualDensity: VisualDensity.compact,
                                    ),
                                    onPressed:
                                        application.status == 'accepted'
                                            ? () {
                                                
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        BlocProvider(
                                                      create: (context) =>
                                                          sl<InterviewViewModel>(),
                                                      child:
                                                          ScheduleInterviewView(
                                                        applicationId:
                                                            application.id,
                                                        applicantName: applicant
                                                            .fullName,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                               
                                              }
                                            : null,
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
}