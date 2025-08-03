import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kamchaiyo/app/service_locator/service_locator.dart';
import 'package:kamchaiyo/features/job_seeker/presentation/view_models/job_search/job_search_bloc.dart';
import 'package:kamchaiyo/features/job_seeker/presentation/views/job_search_view.dart';
import 'package:mocktail/mocktail.dart';

class MockJobSearchBloc extends Mock implements JobSearchBloc {}

void main() {
  group('JobSearchView', () {
    late MockJobSearchBloc mockBloc;

    setUp(() {
      mockBloc = MockJobSearchBloc();
      when(() => mockBloc.state).thenReturn(const JobSearchState());
      when(() => mockBloc.stream).thenAnswer((_) => Stream.value(const JobSearchState()));
      when(() => mockBloc.close()).thenAnswer((_) async {});
      
      if (sl.isRegistered<JobSearchBloc>()) {
        sl.unregister<JobSearchBloc>();
      }
      sl.registerLazySingleton<JobSearchBloc>(() => mockBloc);
    });

    tearDown(() {
      if (sl.isRegistered<JobSearchBloc>()) {
        sl.unregister<JobSearchBloc>();
      }
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: const JobSearchView(),
      );
    }

    testWidgets('should display correct appbar title', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Find Your Dream Job'), findsOneWidget);
    });
  });
} 