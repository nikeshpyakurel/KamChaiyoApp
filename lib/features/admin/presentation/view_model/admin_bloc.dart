import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kamchaiyo/features/admin/domain/entity/chatbot_setting_entity.dart';
import 'package:kamchaiyo/features/admin/domain/entity/company_entity.dart';
import 'package:kamchaiyo/features/admin/domain/use_case/get_all_companies_usecase.dart';
import 'package:kamchaiyo/features/admin/domain/use_case/get_all_users_usecase.dart';
import 'package:kamchaiyo/features/admin/domain/use_case/get_chatbot_settings_usecase.dart';
import 'package:kamchaiyo/features/admin/domain/use_case/toggle_company_verification_usecase.dart';
import 'package:kamchaiyo/features/admin/domain/use_case/update_chatbot_settings_usecase.dart';
import 'package:kamchaiyo/features/auth/domain/entity/user_entity.dart';
import 'package:kamchaiyo/features/auth/domain/use_case/check_auth_status_usecase.dart';

part 'admin_event.dart';
part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final GetAllUsersUseCase _getAllUsersUseCase;
  final GetAllCompaniesUseCase _getAllCompaniesUseCase;
  final ToggleCompanyVerificationUseCase _toggleCompanyVerificationUseCase;
  final GetChatbotSettingsUseCase _getChatbotSettingsUseCase;
  final UpdateChatbotSettingsUseCase _updateChatbotSettingsUseCase;

  AdminBloc({
    required GetAllUsersUseCase getAllUsersUseCase,
    required GetAllCompaniesUseCase getAllCompaniesUseCase,
    required ToggleCompanyVerificationUseCase toggleCompanyVerificationUseCase,
    required GetChatbotSettingsUseCase getChatbotSettingsUseCase,
    required UpdateChatbotSettingsUseCase updateChatbotSettingsUseCase,
  })  : _getAllUsersUseCase = getAllUsersUseCase,
        _getAllCompaniesUseCase = getAllCompaniesUseCase,
        _toggleCompanyVerificationUseCase = toggleCompanyVerificationUseCase,
        _getChatbotSettingsUseCase = getChatbotSettingsUseCase,
        _updateChatbotSettingsUseCase = updateChatbotSettingsUseCase,
        super(const AdminState()) {
    on<AdminDataFetched>(_onAdminDataFetched);
    on<CompanyVerificationToggled>(_onCompanyVerificationToggled);
    on<ChatbotSettingsUpdated>(_onChatbotSettingsUpdated);
  }

  Future<void> _onAdminDataFetched(AdminDataFetched event, Emitter<AdminState> emit) async {
    emit(state.copyWith(status: AdminStatus.loading, clearError: true, clearMessage: true, clearTogglingId: true));

    final usersResult = await _getAllUsersUseCase(NoParams());
    final companiesResult = await _getAllCompaniesUseCase(NoParams());
    final settingsResult = await _getChatbotSettingsUseCase(NoParams());

    usersResult.fold(
      (failure) => emit(state.copyWith(status: AdminStatus.failure, error: failure.message)),
      (users) {
        companiesResult.fold(
          (failure) => emit(state.copyWith(status: AdminStatus.failure, error: failure.message)),
          (companies) {
            settingsResult.fold(
              (failure) => emit(state.copyWith(status: AdminStatus.failure, error: failure.message)),
              (settings) => emit(state.copyWith(status: AdminStatus.success, users: users, companies: companies, chatbotSettings: settings)),
            );
          },
        );
      },
    );
  }

  Future<void> _onCompanyVerificationToggled(CompanyVerificationToggled event, Emitter<AdminState> emit) async {
   
    emit(state.copyWith(togglingCompanyId: event.companyId, clearError: true, clearMessage: true));

    final result = await _toggleCompanyVerificationUseCase(event.companyId);
    
    result.fold(
      (failure) {
        emit(state.copyWith(
          status: AdminStatus.failure, 
          error: failure.message, 
          clearTogglingId: true
        ));
      },
      (updatedCompany) {
        final updatedList = state.companies.map((company) {
          return company.id == updatedCompany.id ? updatedCompany : company;
        }).toList();

        emit(state.copyWith(
          companies: updatedList, 
          status: AdminStatus.success, 
          message: 'Verification status for "${updatedCompany.name}" updated.',
          clearTogglingId: true,
        ));
      },
    );
  }
  
  Future<void> _onChatbotSettingsUpdated(ChatbotSettingsUpdated event, Emitter<AdminState> emit) async {
    emit(state.copyWith(status: AdminStatus.loading, clearError: true, clearMessage: true));

    final result = await _updateChatbotSettingsUseCase(event.newPrompt);
    
    result.fold(
        (failure) => emit(state.copyWith(status: AdminStatus.failure, error: failure.message)),
        (settings) {
          emit(state.copyWith(
            status: AdminStatus.success, 
            chatbotSettings: settings,
            message: 'Chatbot settings saved successfully!',
          ));
        }
    );
  }
}