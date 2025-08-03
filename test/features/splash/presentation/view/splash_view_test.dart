import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kamchaiyo/features/auth/domain/entity/user_entity.dart';
import 'package:kamchaiyo/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:kamchaiyo/features/splash/presentation/view/splash_view.dart';
import 'package:lottie/lottie.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_view_model_mock.dart';


void main() {
  late MockAuthViewModel mockAuthViewModel;
  late MockNavigatorObserver mockNavigatorObserver;

  setUp(() {
    mockAuthViewModel = MockAuthViewModel();
    mockNavigatorObserver = MockNavigatorObserver();
  });

  Future<void> pumpWidget(WidgetTester tester, AuthState initialState) async {
    when(() => mockAuthViewModel.state).thenReturn(initialState);

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthViewModel>.value(
          value: mockAuthViewModel,
          child: const SplashView(),
        ),
        navigatorObservers: [mockNavigatorObserver],
      ),
    );
  }

  testWidgets('renders Lottie animation and app name', (tester) async {
    await pumpWidget(tester, const AuthState(isLoading: true));

    expect(find.byType(Lottie), findsOneWidget);
    expect(find.text('KamChaiyo'), findsOneWidget);
  });

}