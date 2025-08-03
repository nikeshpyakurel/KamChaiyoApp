

import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String? avatar;
  final String? bio;
  final List<String>? skills;
  final String? resumeUrl;

  const ProfileEntity({
    this.avatar,
    this.bio,
    this.skills,
    this.resumeUrl,
  });

  @override
  List<Object?> get props => [avatar, bio, skills, resumeUrl];
}

class UserEntity extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String role;
  final ProfileEntity? profile; 

  const UserEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    this.profile,
  });

  @override
  List<Object?> get props => [id, fullName, email, phone, role, profile];
}