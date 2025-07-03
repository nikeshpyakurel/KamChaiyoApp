import 'package:hive_flutter/hive_flutter.dart';
import 'package:kamchaiyo/app/constant/hive_table_constant.dart';
import 'package:kamchaiyo/features/auth/data/model/auth_hive_model.dart';

class HiveService {
  Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(AuthHiveModelAdapter());


    await Hive.openBox<AuthHiveModel>(HiveTableConstant.sessionBox);
  }
}