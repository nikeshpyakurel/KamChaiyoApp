part of 'admin_bloc.dart';

enum AdminStatus { initial, loading, success, failure }

class AdminState extends Equatable {
  final AdminStatus status;
  final List<UserEntity> users;
  final List<CompanyEntity> companies;
  final ChatbotSettingEntity? chatbotSettings;
  final String? error;

  const AdminState({
    this.status = AdminStatus.initial,
    this.users = const [],
    this.companies = const [],
    this.chatbotSettings,
    this.error,
  });

  AdminState copyWith({AdminStatus? status, List<UserEntity>? users, List<CompanyEntity>? companies, ChatbotSettingEntity? chatbotSettings, String? error, bool clearError = false}) {
    return AdminState(
      status: status ?? this.status,
      users: users ?? this.users,
      companies: companies ?? this.companies,
      chatbotSettings: chatbotSettings ?? this.chatbotSettings,
      error: clearError ? null : error ?? this.error,
    );
  }
  @override
  List<Object?> get props => [status, users, companies, chatbotSettings, error];
}