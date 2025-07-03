import 'package:json_annotation/json_annotation.dart';
import 'package:kamchaiyo/features/auth/data/model/auth_hive_model.dart';
import 'package:kamchaiyo/features/auth/domain/entity/user_entity.dart';
part 'user_dto.g.dart';

@JsonSerializable()
class UserDto {
  @JsonKey(name: '_id')
  final String id;
  final String fullName;
  final String email;
  @JsonKey(name: 'phoneNumber')
  final String phone;
  final String role;

  UserDto({required this.id, required this.fullName, required this.email, required this.phone, required this.role});
  factory UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);
  Map<String, dynamic> toJson() => _$UserDtoToJson(this);
  UserEntity toEntity() => UserEntity(id: id, fullName: fullName, email: email, phone: phone, role: role);
  AuthHiveModel toHiveModel() => AuthHiveModel(id: id, fullName: fullName, email: email, phone: phone, role: role, password: '');
}