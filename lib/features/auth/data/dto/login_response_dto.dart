import 'package:json_annotation/json_annotation.dart';
import 'package:kamchaiyo/features/auth/data/dto/user_dto.dart';
part 'login_response_dto.g.dart';

@JsonSerializable()
class LoginResponseDto {
  final UserDto user;
  final String accessToken;
  final String refreshToken;

  LoginResponseDto({required this.user, required this.accessToken, required this.refreshToken});
  factory LoginResponseDto.fromJson(Map<String, dynamic> json) => _$LoginResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseDtoToJson(this);
}