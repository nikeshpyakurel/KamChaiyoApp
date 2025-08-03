import 'package:flutter_test/flutter_test.dart';
import 'package:kamchaiyo/features/profile/presentation/view_model/profile_bloc.dart';
import 'package:kamchaiyo/features/auth/domain/use_case/update_profile_usecase.dart';
import 'package:kamchaiyo/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:mocktail/mocktail.dart';

class MockUpdateProfileUseCase extends Mock implements UpdateProfileUseCase {}
class MockAuthViewModel extends Mock implements AuthViewModel {}

void main() {
  group('ProfileBloc', () {
    late ProfileBloc profileBloc;
    late MockUpdateProfileUseCase mockUpdateProfileUseCase;
    late MockAuthViewModel mockAuthViewModel;

    setUp(() {
      mockUpdateProfileUseCase = MockUpdateProfileUseCase();
      mockAuthViewModel = MockAuthViewModel();
      profileBloc = ProfileBloc(
        updateProfileUseCase: mockUpdateProfileUseCase,
        authViewModel: mockAuthViewModel,
      );
    });

    tearDown(() {
      profileBloc.close();
    });

    test('initial state should be ProfileState with initial status', () {
      expect(profileBloc.state, const ProfileState(status: ProfileStatus.initial));
    });
  });
} 