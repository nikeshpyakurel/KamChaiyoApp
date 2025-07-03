import 'package:hive/hive.dart';
import 'package:kamchaiyo/app/constant/hive_table_constant.dart';
import 'package:kamchaiyo/features/auth/domain/entity/user_entity.dart';

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

  AuthHiveModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    this.role,   
    this.password,
  });

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      fullName: fullName,
      email: email,
      phone: phone,
      role: role ?? 'student', 
    );
  }
}