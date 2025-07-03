// import 'package:hive/hive.dart';
// import 'package:kamchaiyo/app/constant/hive_table_constant.dart';
// import 'package:kamchaiyo/features/auth/domain/entity/user_entity.dart';
// import 'package:uuid/uuid.dart';

// part 'auth_hive_model.g.dart';

// @HiveType(typeId: HiveTableConstant.userTypeId)
// class AuthHiveModel {
//   @HiveField(0)
//   final String id;
//   @HiveField(1)
//   final String fullName;
//   @HiveField(2)
//   final String email;
//   @HiveField(3)
//   final String phone;
//   @HiveField(4)
//   final String password;

//   AuthHiveModel({String? id, required this.fullName, required this.email, required this.phone, required this.password}) : id = id ?? const Uuid().v4();

//   UserEntity toEntity() => UserEntity(id: id, fullName: fullName, email: email, phone: phone);
// }


import 'package:hive/hive.dart';
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

  // ------------------------- THE FIX IS HERE -------------------------
  // Make the new field nullable to handle old data that doesn't have it.
  @HiveField(4)
  final String? role; 

  // The password field was also added later. Make it nullable too.
  @HiveField(5)
  final String? password;
  // -------------------------------------------------------------------

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