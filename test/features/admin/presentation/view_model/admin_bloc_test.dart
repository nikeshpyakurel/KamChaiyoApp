import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kamchaiyo/core/error/failure.dart'; // Assuming you have a Failure class
import 'package:kamchaiyo/features/admin/domain/entity/chatbot_setting_entity.dart';
import 'package:kamchaiyo/features/admin/domain/entity/company_entity.dart';
import 'package:kamchaiyo/features/admin/domain/use_case/get_all_companies_usecase.dart';
import 'package:kamchaiyo/features/admin/domain/use_case/get_all_users_usecase.dart';
import 'package:kamchaiyo/features/admin/domain/use_case/get_chatbot_settings_usecase.dart';
import 'package:kamchaiyo/features/admin/domain/use_case/toggle_company_verification_usecase.dart';
import 'package:kamchaiyo/features/admin/domain/use_case/update_chatbot_settings_usecase.dart';
import 'package:kamchaiyo/features/admin/presentation/view_model/admin_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAllUsersUseCase extends Mock implements GetAllUsersUseCase {}
class MockGetAllCompaniesUseCase extends Mock implements GetAllCompaniesUseCase {}
class MockToggleCompanyVerificationUseCase extends Mock implements ToggleCompanyVerificationUseCase {}
class MockGetChatbotSettingsUseCase extends Mock implements GetChatbotSettingsUseCase {}
class MockUpdateChatbotSettingsUseCase extends Mock implements UpdateChatbotSettingsUseCase {}

void main() {
  late AdminBloc adminBloc;
  late MockGetAllUsersUseCase mockGetAllUsersUseCase;
  late MockGetAllCompaniesUseCase mockGetAllCompaniesUseCase;
  late MockToggleCompanyVerificationUseCase mockToggleCompanyVerificationUseCase;
  late MockGetChatbotSettingsUseCase mockGetChatbotSettingsUseCase;
  late MockUpdateChatbotSettingsUseCase mockUpdateChatbotSettingsUseCase;

  setUp(() {
    mockGetAllUsersUseCase = MockGetAllUsersUseCase();
    mockGetAllCompaniesUseCase = MockGetAllCompaniesUseCase();
    mockToggleCompanyVerificationUseCase = MockToggleCompanyVerificationUseCase();
    mockGetChatbotSettingsUseCase = MockGetChatbotSettingsUseCase();
    mockUpdateChatbotSettingsUseCase = MockUpdateChatbotSettingsUseCase();

    adminBloc = AdminBloc(
      getAllUsersUseCase: mockGetAllUsersUseCase,
      getAllCompaniesUseCase: mockGetAllCompaniesUseCase,
      toggleCompanyVerificationUseCase: mockToggleCompanyVerificationUseCase,
      getChatbotSettingsUseCase: mockGetChatbotSettingsUseCase,
      updateChatbotSettingsUseCase: mockUpdateChatbotSettingsUseCase,
    );
  });
  
  tearDown(() {
    adminBloc.close();
  });

  final tFailure = ServerFailure(message: 'An error occurred');

  test('initial state is correct', () {
    expect(adminBloc.state, const AdminState());
  });

  group('ChatbotSettingsUpdated', () {
    const tNewPrompt = 'This is a new prompt';
    final tNewSettings = const ChatbotSettingEntity(id: '22', systemPrompt: tNewPrompt);

    blocTest<AdminBloc, AdminState>(
      'should emit [loading, success with new settings] on successful update',
      build: () {
        // Arrange
        when(() => mockUpdateChatbotSettingsUseCase(tNewPrompt)).thenAnswer((_) async => Right(tNewSettings));
        return adminBloc;
      },
      act: (bloc) => bloc.add(const ChatbotSettingsUpdated(tNewPrompt)),
      expect: () => <AdminState>[
        const AdminState().copyWith(status: AdminStatus.loading, clearError: true, clearMessage: true),
        const AdminState().copyWith(
          status: AdminStatus.success,
          chatbotSettings: tNewSettings,
          message: 'Chatbot settings saved successfully!',
        ),
      ],
      verify: (_) {
        verify(() => mockUpdateChatbotSettingsUseCase(tNewPrompt)).called(1);
      },
    );

    blocTest<AdminBloc, AdminState>(
      'should emit [loading, failure] on failed update',
      build: () {
        // Arrange
        when(() => mockUpdateChatbotSettingsUseCase(tNewPrompt)).thenAnswer((_) async => Left(tFailure));
        return adminBloc;
      },
      act: (bloc) => bloc.add(const ChatbotSettingsUpdated(tNewPrompt)),
      expect: () => <AdminState>[
        const AdminState().copyWith(status: AdminStatus.loading, clearError: true, clearMessage: true),
        const AdminState().copyWith(status: AdminStatus.failure, error: tFailure.message),
      ],
      verify: (_) {
        verify(() => mockUpdateChatbotSettingsUseCase(tNewPrompt)).called(1);
      },
    );
  });
}