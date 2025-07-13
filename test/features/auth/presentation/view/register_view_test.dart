import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kamchaiyo/app/config/app_config.dart';
import 'package:kamchaiyo/features/auth/presentation/view/register_view.dart';
import 'package:kamchaiyo/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:mocktail/mocktail.dart';


class MockAuthViewModel extends MockBloc<AuthEvent, AuthState> implements AuthViewModel {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class TestAuthState extends AuthState {
  const TestAuthState({
    bool isLoading = false,
    String? error,
    bool signupSuccess = false,
  }) : super(
          isLoading: isLoading,
          error: error,
          signupSuccess: signupSuccess,
        );
}

void main() {
  late AuthViewModel mockAuthViewModel;
  late NavigatorObserver mockNavigatorObserver;

  setUpAll(() {
    AppConfig.isTestMode = true;
    registerFallbackValue(const SignupRequested(
      fullName: '', email: '', phone: '', password: '', role: '',
    ));
  });

  setUp(() {
    mockAuthViewModel = MockAuthViewModel();
    mockNavigatorObserver = MockNavigatorObserver();
  });

  Future<void> pumpRegisterView(WidgetTester tester) async {
    when(() => mockAuthViewModel.state).thenReturn(const TestAuthState());

    await tester.pumpWidget(
      BlocProvider<AuthViewModel>.value(
        value: mockAuthViewModel,
        child: MaterialApp(
          home: const RegisterView(),
          navigatorObservers: [mockNavigatorObserver],
        ),
      ),
    );
  }

  group('RegisterView', () {
    testWidgets('should render all static text and form fields correctly', (tester) async {
      // Act
      await pumpRegisterView(tester);

      // Assert
      expect(find.text('Create Account'), findsOneWidget);
      expect(find.text('I am a...'), findsOneWidget);
      expect(find.text('Job Seeker'), findsOneWidget);
      expect(find.text('Recruiter'), findsOneWidget);

      expect(find.widgetWithText(TextFormField, 'Full Name'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Phone Number'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Confirm Password'), findsOneWidget);
      
      expect(find.widgetWithText(ElevatedButton, 'Sign Up'), findsOneWidget);
    });

    testWidgets('should show error SnackBar when state has an error', (tester) async {
      // Arrange
      whenListen(
        mockAuthViewModel,
        Stream.fromIterable([const TestAuthState(error: 'Email already exists')]),
        initialState: const TestAuthState(),
      );
      
      // Act
      await pumpRegisterView(tester);
      await tester.pump();

      // Assert
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Email already exists'), findsOneWidget);
    });
  });
}