import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kamchaiyo/app/service_locator/service_locator.dart';
import 'package:kamchaiyo/common/snake_bar.dart';
import 'package:kamchaiyo/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:kamchaiyo/features/recruiter_profile/presentation/view_model/recruiter_profile_cubit.dart';
import 'package:kamchaiyo/features/recruiter_profile/presentation/view_model/recruiter_profile_state.dart';

class RecruiterProfileView extends StatelessWidget {
  const RecruiterProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<RecruiterProfileCubit>(),
      child: const _RecruiterProfileContent(),
    );
  }
}

class _RecruiterProfileContent extends StatefulWidget {
  const _RecruiterProfileContent();

  @override
  State<_RecruiterProfileContent> createState() => __RecruiterProfileContentState();
}

class __RecruiterProfileContentState extends State<_RecruiterProfileContent> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fullNameController;
  File? _avatarImage;

  @override
  void initState() {
    super.initState();
    final currentUser = context.read<AuthViewModel>().state.user;
    _fullNameController = TextEditingController(text: currentUser?.fullName ?? '');
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source, imageQuality: 70);
      if (image == null) return;
      if (mounted) {
        setState(() => _avatarImage = File(image.path));
      }
    } catch (e) {
      debugPrint('Failed to pick image: $e');
    }
  }

  void _updateProfile(BuildContext cubitContext) {
    if (_formKey.currentState!.validate()) {
      cubitContext.read<RecruiterProfileCubit>().updateRecruiterProfile(
            fullName: _fullNameController.text.trim(),
            avatar: _avatarImage,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: BlocConsumer<RecruiterProfileCubit, RecruiterProfileState>(
        listener: (context, state) {
          if (state.status == RecruiterProfileStatus.success) {
            showSnackBar(context: context, message: 'Profile updated successfully!', color: Colors.green);
            if (mounted) {
              setState(() => _avatarImage = null);
            }
          } else if (state.status == RecruiterProfileStatus.failure) {
            showSnackBar(context: context, message: state.error ?? 'An error occurred.', color: Colors.red);
          }
        },
        builder: (cubitContext, state) {
          final user = context.watch<AuthViewModel>().state.user;

          return ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: _avatarImage != null
                          ? FileImage(_avatarImage!)
                          : (user?.profile?.avatar != null && user!.profile!.avatar!.isNotEmpty
                              ? NetworkImage(user.profile!.avatar!)
                              : null) as ImageProvider?,
                      child: _avatarImage == null && (user?.profile?.avatar == null || user!.profile!.avatar!.isEmpty)
                          ? Text(user?.fullName[0].toUpperCase() ?? '?', style: const TextStyle(fontSize: 50))
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 20,
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, size: 20),
                          onPressed: () => _pickImage(ImageSource.gallery),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Center(
                  child: Text(user?.email ?? 'No Email',
                      style: Theme.of(context).textTheme.titleMedium)),
              const SizedBox(height: 32),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _fullNameController,
                  decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline)),
                  validator: (v) => v!.trim().isEmpty ? 'Full name cannot be empty' : null,
                ),
              ),
              const SizedBox(height: 24),
              if (state.status == RecruiterProfileStatus.loading)
                const Center(child: CircularProgressIndicator())
              else
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16)
                  ),
                  onPressed: () => _updateProfile(cubitContext),
                  child: const Text('Save Changes'),
                ),
            ],
          );
        },
      ),
    );
  }
}