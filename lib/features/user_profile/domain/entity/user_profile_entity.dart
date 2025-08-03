import 'package:equatable/equatable.dart';

class UserProfileEntity extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String? bio;
  final List<String> skills;
  final String? resumeUrl;
  final String? resumeOriginalName;
  final String? avatarUrl;

  const UserProfileEntity({
    required this.id,
    required this.fullName,
    required this.email,
    this.bio,
    required this.skills,
    this.resumeUrl,
    this.resumeOriginalName,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [
        id,
        fullName,
        email,
        bio,
        skills,
        resumeUrl,
        resumeOriginalName,
        avatarUrl
      ];
}