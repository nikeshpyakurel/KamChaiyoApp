import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kamchaiyo/features/my_interviews/presentation/view/student_my_interviews_view.dart';
import 'package:kamchaiyo/features/my_interviews/presentation/view_model/my_interviews_state.dart';
import 'package:kamchaiyo/features/my_interviews/presentation/view_model/my_interviews_view_model.dart';
import 'package:mocktail/mocktail.dart';

class MockMyInterviewsViewModel extends Mock implements MyInterviewsViewModel {}

void main() {
  group('StudentMyInterviewsView', () {
    late MockMyInterviewsViewModel mockViewModel;

    setUp(() {
      mockViewModel = MockMyInterviewsViewModel();
      when(() => mockViewModel.state).thenReturn(const MyInterviewsState());
      when(() => mockViewModel.stream).thenAnswer((_) => Stream.value(const MyInterviewsState()));
      when(() => mockViewModel.close()).thenAnswer((_) async {});
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: BlocProvider<MyInterviewsViewModel>.value(
          value: mockViewModel,
          child: const StudentMyInterviewsView(),
        ),
      );
    }

    testWidgets('should display correct appbar title', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('My Interviews'), findsOneWidget);
    });
  });
} 