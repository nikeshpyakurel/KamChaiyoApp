import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kamchaiyo/features/auth/domain/entity/user_entity.dart';
import 'package:kamchaiyo/features/auth/presentation/view/login_view.dart';
import 'package:kamchaiyo/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthViewModel extends MockBloc<AuthEvent, AuthState> implements AuthViewModel {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class TestAuthState extends AuthState {
  const TestAuthState({
    bool isLoading = false,
    String? error,
    UserEntity? user,
    bool isAuthenticated = false,
  }) : super(
          isLoading: isLoading,
          error: error,
          user: user,
          isAuthenticated: isAuthenticated,
        );
}

void main() {
  late AuthViewModel mockAuthViewModel;
  late NavigatorObserver mockNavigatorObserver;

  setUp(() {
    mockAuthViewModel = MockAuthViewModel();
    mockNavigatorObserver = MockNavigatorObserver();
    registerFallbackValue(MaterialPageRoute(builder: (_) => const SizedBox()));
  });

  Future<void> pumpLoginView(WidgetTester tester) async {
    await tester.pumpWidget(
      BlocProvider<AuthViewModel>.value(
        value: mockAuthViewModel,
        child: MaterialApp(
          home: const LoginView(),
          navigatorObservers: [mockNavigatorObserver], 
        ),
      ),
    );
  }
  const initialIdleState = TestAuthState();

  group('LoginView', () {
  // testWidgets('renders user and admin login forms correctly in tabs', (tester) async {
  //     // Arrange: Set the initial state of the BLoC
  //     when(() => mockAuthViewModel.state).thenReturn(initialIdleState);

  //     await pumpLoginView(tester);
  //     await tester.pumpAndSettle();

  //     expect(find.text('Welcome Back!'), findsOneWidget);
  //     expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
  //     expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
  //     expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);

  //     await tester.tap(find.text('Admin'));
  //     await tester.pumpAndSettle();

  //     expect(find.text('Admin Portal'), findsOneWidget);
  //     expect(find.widgetWithText(TextFormField, 'Admin Email'), findsOneWidget);
  //     expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
  //     expect(find.widgetWithText(ElevatedButton, 'Login as Admin'), findsOneWidget);
  //   });


    testWidgets('shows CircularProgressIndicator when state is loading', (tester) async {
      // Arrange: Set state to loading
      when(() => mockAuthViewModel.state).thenReturn(const TestAuthState(isLoading: true));

      // Act
      await pumpLoginView(tester);

      // Assert: 
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Login'), findsNothing);
    });

    
    testWidgets('shows SnackBar when state has an error', (tester) async {
       // Arrange
      whenListen(
        mockAuthViewModel,
        Stream.fromIterable([const TestAuthState(error: 'Invalid credentials')]),
        initialState: initialIdleState,
      );

      // Act
      await pumpLoginView(tester);
      await tester.pump(); 

      // Assert
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Invalid credentials'), findsOneWidget);
    });
  });
}