import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kamchaiyo/common/snake_bar.dart';
import 'package:kamchaiyo/features/auth/domain/use_case/update_profile_usecase.dart';
import 'package:kamchaiyo/features/auth/presentation/view_model/auth_view_model.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});
  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _fullNameController = TextEditingController();
  File? _avatarImage;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      setState(() => _avatarImage = File(image.path));
    } catch (e) { debugPrint('Failed to pick image: $e'); }
  }

  void _updateProfile() {
    context.read<AuthViewModel>().add(UpdateProfileRequested(
        UpdateProfileParams(fullName: _fullNameController.text.trim(), avatar: _avatarImage)));
  }

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthViewModel>().state.user;
    if (user != null) {
      _fullNameController.text = user.fullName;
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Profile')),
      body: BlocListener<AuthViewModel, AuthState>(
        listener: (context, state) {
          if (state.profileUpdateSuccess) {
            showSnackBar(context: context, message: 'Profile updated successfully!', color: Colors.green);
          } else if (state.error != null) {
            showSnackBar(context: context, message: state.error!, color: Colors.red);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(radius: 60, backgroundImage: _avatarImage != null ? FileImage(_avatarImage!) : null, child: _avatarImage == null ? const Icon(Icons.person, size: 60) : null),
                  Positioned(bottom: 0, right: 0, child: IconButton(icon: const Icon(Icons.camera_alt), onPressed: () => _pickImage(ImageSource.gallery))),
                ],
              ),
              const SizedBox(height: 24),
              TextFormField(controller: _fullNameController, decoration: const InputDecoration(labelText: 'Full Name')),
              const SizedBox(height: 32),
              BlocBuilder<AuthViewModel, AuthState>(
                builder: (context, state) {
                  if (state.isLoading) { return const CircularProgressIndicator(); }
                  return SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _updateProfile, child: const Text('Save Changes')));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}