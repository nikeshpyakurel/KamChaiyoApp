import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kamchaiyo/core/network/hive_service.dart';
import 'package:kamchaiyo/features/auth/auth_injection_container.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  sl.registerLazySingleton<HiveService>(() => HiveService());
  await sl<HiveService>().init();

  sl.registerLazySingleton<HiveInterface>(() => Hive);

  initAuthInjection(sl);
}