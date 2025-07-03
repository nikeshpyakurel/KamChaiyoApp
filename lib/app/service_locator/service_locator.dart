import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kamchaiyo/core/network/auth_interceptor.dart';
import 'package:kamchaiyo/core/network/dio_client.dart';
import 'package:kamchaiyo/core/network/hive_service.dart';
import 'package:kamchaiyo/features/admin/admin_injection_container.dart'; 
import 'package:kamchaiyo/features/auth/auth_injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  sl.registerLazySingleton<HiveService>(() => HiveService());
  await sl<HiveService>().init();
  sl.registerLazySingleton<HiveInterface>(() => Hive);

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Networking
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => AuthInterceptor(sl()));
  sl.registerLazySingleton(() => DioClient(sl(), sl()));
  
  initAuthInjection(sl);
  initAdminInjection(sl);
}