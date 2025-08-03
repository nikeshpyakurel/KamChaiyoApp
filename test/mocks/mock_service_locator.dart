import 'package:get_it/get_it.dart';
import 'package:kamchaiyo/features/admin/presentation/view_model/admin_bloc.dart';
import 'package:mocktail/mocktail.dart';

final sl = GetIt.instance;

class MockAdminBloc extends Mock implements AdminBloc {}

void setupMockServiceLocator({required AdminBloc adminBloc}) {
  sl.reset();
  sl.registerFactory<AdminBloc>(() => adminBloc);
}