part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileUpdateSubmitted extends ProfileEvent {
  final String fullName;
  final String bio;
  final List<String> skills;
  final File? avatar;
  final File? resume;

  const ProfileUpdateSubmitted({
    required this.fullName,
    required this.bio,
    required this.skills,
    this.avatar,
    this.resume,
  });

  @override
  List<Object?> get props => [fullName, bio, skills, avatar, resume];
}