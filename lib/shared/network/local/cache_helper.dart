import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences cacheHelper;
  static init() async {
    cacheHelper = await SharedPreferences.getInstance();
  }

  static Future<bool?> saveData(String key, value) async {
    if (value is bool) return await cacheHelper.setBool(key, value);
    if (value is String) return await cacheHelper.setString(key, value);
    if (value is int) return await cacheHelper.setInt(key, value);
    return null;
  }

  static getData(String key)async {
    return await cacheHelper.get(key);
  }

  static Future<bool> removeData({required String? key}) async{
    return await cacheHelper.remove(key!);
  }
}
