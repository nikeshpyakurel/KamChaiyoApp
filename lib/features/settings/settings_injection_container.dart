import 'package:get_it/get_it.dart';
import 'package:kamchaiyo/features/settings/presentation/view_model/settings_cubit.dart';

void initSettingsInjection(GetIt sl) {
  sl.registerLazySingleton(() => SettingsCubit(prefs: sl()));
}