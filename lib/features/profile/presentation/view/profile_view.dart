import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamchaiyo/core/services/biometric_service.dart';
import 'package:kamchaiyo/features/auth/presentation/view/login_view.dart';
import 'package:kamchaiyo/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:kamchaiyo/features/profile/presentation/view/edit_profile_view.dart';
import 'package:kamchaiyo/features/profile/presentation/view_model/profile_bloc.dart';
import 'package:kamchaiyo/features/settings/presentation/view_model/settings_cubit.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthViewModel>().state.user;

    if (user == null) {
      return const Center(child: Text("User not found. Please log in again."));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthViewModel>().add(LogoutRequested());
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginView()),
                  (route) => false);
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: user.profile?.avatar != null
                    ? NetworkImage(user.profile!.avatar!)
                    : null,
                child: user.profile?.avatar == null
                    ? Text(user.fullName[0].toUpperCase(), style: const TextStyle(fontSize: 40))
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            Text(user.fullName, style: Theme.of(context).textTheme.headlineSmall),
            Text(user.email, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600)),
            const SizedBox(height: 24),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Edit Profile'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<ProfileBloc>(),
                      child: const EditProfileView(),
                    ),
                  ),
                );
              },
            ),
            const Divider(),
          
          BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, state) {
              return SwitchListTile(
                title: const Text('Enable Biometric Lock'),
                secondary: const Icon(Icons.fingerprint),
                value: state.isBiometricEnabled,
                onChanged: (bool value) async {
                  if (value) {
                    if (await BiometricService.canAuthenticate()) {
                      context.read<SettingsCubit>().toggleBiometric(value);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Biometrics not available on this device.")),
                      );
                    }
                  } else {
                    context.read<SettingsCubit>().toggleBiometric(value);
                  }
                },
              );
            },
          ),
            
          ],
        ),
      ),
    );
  }
}