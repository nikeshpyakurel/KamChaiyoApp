import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kamchaiyo/features/my_applications/presentation/view/my_applications_view.dart';
import 'package:kamchaiyo/features/my_applications/presentation/view_model/my_applications_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockMyApplicationsBloc extends Mock implements MyApplicationsBloc {}

void main() {
  group('MyApplicationsView', () {
    late MockMyApplicationsBloc mockBloc;

    setUp(() {
      mockBloc = MockMyApplicationsBloc();
      when(() => mockBloc.state).thenReturn(const MyApplicationsState());
      when(() => mockBloc.stream).thenAnswer((_) => Stream.value(const MyApplicationsState()));
      when(() => mockBloc.close()).thenAnswer((_) async {});
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: BlocProvider<MyApplicationsBloc>.value(
          value: mockBloc,
          child: const MyApplicationsView(),
        ),
      );
    }

    testWidgets('should display correct appbar title', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('My Applications'), findsOneWidget);
    });
  });
} 