class HiveTableConstant {
  HiveTableConstant._();

  // Type IDs must be unique for each HiveObject.
  static const int userTypeId = 0;
  
  // Box names for storing data.
  static const String userBox = 'userBox';
  static const String sessionBox = 'sessionBox';
}