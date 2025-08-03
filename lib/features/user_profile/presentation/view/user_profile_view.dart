import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamchaiyo/app/service_locator/service_locator.dart';
import 'package:kamchaiyo/features/user_profile/domain/entity/user_profile_entity.dart';
import 'package:kamchaiyo/features/user_profile/presentation/view_model/user_profile_event.dart';
import 'package:kamchaiyo/features/user_profile/presentation/view_model/user_profile_state.dart';
import 'package:kamchaiyo/features/user_profile/presentation/view_model/user_profile_view_model.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfileView extends StatelessWidget {
  final String userId;
  const UserProfileView({super.key, required this.userId});

  Future<void> _launchURL(BuildContext context, String? urlString) async {
    if (urlString == null || urlString.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No resume URL has been provided by the applicant.')),
      );
      return;
    }
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch resume link: $urlString')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<UserProfileViewModel>()..add(UserProfileFetched(userId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Applicant Profile'),
        ),
        body: BlocBuilder<UserProfileViewModel, UserProfileState>(
          builder: (context, state) {
            if (state.status == UserProfileStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == UserProfileStatus.failure || state.userProfile == null) {
              return Center(child: Text(state.error ?? 'Could not load profile.'));
            }

            final profile = state.userProfile!;

            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildHeader(context, profile),
                const SizedBox(height: 24),

                if (profile.bio != null && profile.bio!.isNotEmpty)
                  _buildSectionCard(
                    title: 'About Me',
                    child: Text(profile.bio!),
                  ),

                if (profile.skills.isNotEmpty)
                  _buildSectionCard(
                    title: 'Skills',
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: profile.skills
                          .map((skill) => Chip(label: Text(skill)))
                          .toList(),
                    ),
                  ),

                
                if (profile.resumeUrl != null && profile.resumeUrl!.isNotEmpty)
                  _buildSectionCard(
                    title: 'Resume / CV',
                    child: ListTile(
                      leading: const Icon(Icons.description_outlined, color: Colors.blueGrey),
                      title: Text(
                        profile.resumeOriginalName ?? 'View Attached Resume',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      trailing: const Icon(Icons.open_in_new),
                      onTap: () => _launchURL(context, profile.resumeUrl),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, UserProfileEntity profile) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage:
              profile.avatarUrl != null ? NetworkImage(profile.avatarUrl!) : null,
          child: profile.avatarUrl == null
              ? Text(profile.fullName[0].toUpperCase(), style: const TextStyle(fontSize: 40))
              : null,
        ),
        const SizedBox(height: 16),
        Text(
          profile.fullName,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 4),
        Text(
          profile.email,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(height: 24),
            child,
          ],
        ),
      ),
    );
  }
}