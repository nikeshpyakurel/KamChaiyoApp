import 'package:hive_flutter/hive_flutter.dart';
import 'package:kamchaiyo/app/constant/hive_table_constant.dart';
import 'package:kamchaiyo/features/auth/domain/entity/user_entity.dart';

part 'auth_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.userTypeId)
class AuthHiveModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String fullName;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String phone;
  @HiveField(4)
  final String? role;
  @HiveField(5)
  final String? password;
  @HiveField(6)
  final String? avatar;

  // Add new fields with unique HiveField numbers
  @HiveField(7)
  final String? bio;
  @HiveField(8)
  final List<String>? skills;

  AuthHiveModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    this.role,
    this.password,
    this.avatar,
    this.bio,     // Add to constructor
    this.skills,  // Add to constructor
  });

  /// Maps the data from the local database (Hive) to your app's internal model (Entity).
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      fullName: fullName,
      email: email,
      phone: phone,
      role: role ?? 'student',
      profile: ProfileEntity(
        avatar: avatar,
        bio: bio,
        skills: skills,
      ),
    );
  }

  /// Maps the data from your app's internal model (Entity) to the local database model (Hive).
  factory AuthHiveModel.fromEntity(UserEntity entity, {String? password}) {
    return AuthHiveModel(
      id: entity.id,
      fullName: entity.fullName,
      email: entity.email,
      phone: entity.phone,
      role: entity.role,
      password: password,
      avatar: entity.profile?.avatar,
      bio: entity.profile?.bio,
      skills: entity.profile?.skills,
    );
  }
}