import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:kamchaiyo/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthViewModel extends MockBloc<AuthEvent, AuthState>
    implements AuthViewModel {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}