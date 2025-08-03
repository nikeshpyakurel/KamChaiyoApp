import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kamchaiyo/common/snake_bar.dart';
import 'package:kamchaiyo/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:kamchaiyo/features/profile/presentation/view_model/profile_bloc.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  late final TextEditingController _nameController;
  late final TextEditingController _bioController;
  late final TextEditingController _skillsController;

  File? _avatarImage;
  File? _resumeFile;
  String? _resumeFileName;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthViewModel>().state.user;
    final userProfile = user?.profile;

    _nameController = TextEditingController(text: user?.fullName ?? '');
    _bioController = TextEditingController(text: userProfile?.bio ?? '');
    _skillsController =
        TextEditingController(text: userProfile?.skills?.join(', ') ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _skillsController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    try {
      final pickedFile = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 70);
      if (pickedFile != null) {
        setState(() {
          _avatarImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint("Avatar picking failed: $e");
    }
  }

  Future<void> _pickResume() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );
      if (result != null) {
        setState(() {
          _resumeFile = File(result.files.single.path!);
          _resumeFileName = result.files.single.name;
        });
      }
    } catch (e) {
      debugPrint("Resume picking failed: $e");
    }
  }

  void _submitProfile() {
    if (_nameController.text.trim().isEmpty) {
      showSnackBar(
          context: context,
          message: "Full Name cannot be empty.",
          color: Colors.red);
      return;
    }

    final skillsList = _skillsController.text
        .split(',')
        .map((skill) => skill.trim())
        .where((skill) => skill.isNotEmpty)
        .toList();

    context.read<ProfileBloc>().add(
          ProfileUpdateSubmitted(
            fullName: _nameController.text.trim(),
            bio: _bioController.text.trim(),
            skills: skillsList,
            avatar: _avatarImage,
            resume: _resumeFile,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<AuthViewModel>().state.user;

    ImageProvider? currentAvatar;
    if (_avatarImage != null) {
      currentAvatar = FileImage(_avatarImage!);
    } else if (currentUser?.profile?.avatar != null &&
        currentUser!.profile!.avatar!.isNotEmpty) {
      currentAvatar = NetworkImage(currentUser.profile!.avatar!);
    }

    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.status == ProfileStatus.success) {
          showSnackBar(
              context: context,
              message: state.successMessage!,
              color: Colors.green);
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        }
        if (state.status == ProfileStatus.failure) {
          showSnackBar(
              context: context, message: state.error!, color: Colors.red);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Edit Profile')),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: currentAvatar, 
                    child: (currentAvatar == null)
                        ? const Icon(Icons.person, size: 60)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 20,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, size: 20),
                        onPressed: _pickAvatar,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                  labelText: 'Full Name', prefixIcon: Icon(Icons.person)),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _bioController,
              decoration: const InputDecoration(
                  labelText: 'Bio (A short intro about yourself)',
                  prefixIcon: Icon(Icons.info_outline)),
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _skillsController,
              decoration: const InputDecoration(
                  labelText: 'Skills (comma-separated)',
                  hintText: 'e.g., Flutter, Firebase, BLoC',
                  prefixIcon: Icon(Icons.psychology_alt)),
            ),
            const SizedBox(height: 16),

            ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.grey.shade300)),
              leading: const Icon(Icons.description_outlined),
              title: Text(_resumeFileName ?? "Upload a new Resume"),
              trailing: const Icon(Icons.upload_file),
              onTap: _pickResume,
            ),
            const SizedBox(height: 32),

            BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state.status == ProfileStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ElevatedButton(
                  onPressed: _submitProfile,
                  child: const Text('Save Changes'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}