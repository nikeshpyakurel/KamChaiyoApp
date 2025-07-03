part of 'admin_bloc.dart';

enum AdminStatus { initial, loading, success, failure }

class AdminState extends Equatable {
  final AdminStatus status;
  final List<UserEntity> users;
  final List<CompanyEntity> companies;
  final ChatbotSettingEntity? chatbotSettings;
  final String? error;

  final String? message;
  final String? togglingCompanyId;

  const AdminState({
    this.status = AdminStatus.initial,
    this.users = const [],
    this.companies = const [],
    this.chatbotSettings,
    this.error,
    this.message,
    this.togglingCompanyId,
  });

  AdminState copyWith({
    AdminStatus? status,
    List<UserEntity>? users,
    List<CompanyEntity>? companies,
    ChatbotSettingEntity? chatbotSettings,
    String? error,
    String? message,
    String? togglingCompanyId,
    bool clearError = false,
    bool clearMessage = false,
    bool clearTogglingId = false,
  }) {
    return AdminState(
      status: status ?? this.status,
      users: users ?? this.users,
      companies: companies ?? this.companies,
      chatbotSettings: chatbotSettings ?? this.chatbotSettings,
      error: clearError ? null : error ?? this.error,
      message: clearMessage ? null : message ?? this.message,
      togglingCompanyId: clearTogglingId ? null : togglingCompanyId ?? this.togglingCompanyId,
    );
  }

  @override
  List<Object?> get props => [status, users, companies, chatbotSettings, error, message, togglingCompanyId];
}