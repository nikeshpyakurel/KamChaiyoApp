import 'package:hive_flutter/hive_flutter.dart';
import 'package:kamchaiyo/app/constant/hive_table_constant.dart';
import 'package:kamchaiyo/features/auth/data/model/auth_hive_model.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);

    Hive.registerAdapter(AuthHiveModelAdapter());

    await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
    await Hive.openBox<AuthHiveModel>(HiveTableConstant.sessionBox);
  }
}