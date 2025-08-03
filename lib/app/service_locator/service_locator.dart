import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kamchaiyo/core/network/auth_interceptor.dart';
import 'package:kamchaiyo/core/network/dio_client.dart';
import 'package:kamchaiyo/core/network/hive_service.dart';
import 'package:kamchaiyo/features/admin/admin_injection_container.dart';
import 'package:kamchaiyo/features/application/application_injection_container.dart'; 
import 'package:kamchaiyo/features/auth/auth_injection_container.dart';
import 'package:kamchaiyo/features/chat/chat_injection_container.dart';
import 'package:kamchaiyo/features/chatbot/chatbot_injection_container.dart';
import 'package:kamchaiyo/features/company/company_injection_container.dart';
import 'package:kamchaiyo/features/company_detail/company_detail_injection_container.dart';
import 'package:kamchaiyo/features/home/home_injection_container.dart';
import 'package:kamchaiyo/features/interview/interview_injection_container.dart';
import 'package:kamchaiyo/features/job/job_injection_container.dart';
import 'package:kamchaiyo/features/job_detail/job_detail_injection_container.dart';
import 'package:kamchaiyo/features/my_applications/my_applications_injection_container.dart';
import 'package:kamchaiyo/features/my_interviews/my_interviews_injection_container.dart';
import 'package:kamchaiyo/features/notification/notification_injection_container.dart';
import 'package:kamchaiyo/features/profile/profile_injection_container.dart';
import 'package:kamchaiyo/features/recruiter_dashboard/recruiter_injection_container.dart';
import 'package:kamchaiyo/features/recruiter_profile/recruiter_profile_injection_container.dart';
import 'package:kamchaiyo/features/search/search_injection_container.dart';
import 'package:kamchaiyo/features/user_profile/user_profile_injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  sl.registerLazySingleton<HiveService>(() => HiveService());
  await sl<HiveService>().init();
  sl.registerLazySingleton<HiveInterface>(() => Hive);

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => AuthInterceptor(sl()));
  sl.registerLazySingleton(() => DioClient(sl(), sl()));
  
  initAuthInjection(sl);
  initAdminInjection(sl);
  initCompanyInjection(sl);
  initJobInjection(sl); 
  initApplicationInjection(sl);
  initUserProfileInjection(sl);
  initInterviewInjection(sl);
  initMyInterviewsInjection(sl);
  initRecruiterProfileInjection(sl);
  initRecruiterDashboardInjection(sl);
  initChatInjection(sl);
  // initJobSeekerInjection(sl); 
  initHomeInjection(sl); // New
  initMyApplicationsInjection(sl); // New
  initProfileInjection(sl); 
  initSearchInjection(sl);
    initJobDetailInjection(sl); // New

  initChatbotInjection(sl); // New
    initNotificationInjection(sl); // New
  initCompanyDetailInjection(sl); // New




}