import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static const isFinishOnBoardingKey = "isFinishOnBoardingKey";
  static const languageCodeKey = "languageCodeKey";
  static const isLogin = "isLogin";
  static const userId = "userId";
  static const user = "userData";
  static const paymentSetting = "paymentSetting";
  static const currency = "currency";
  static const accesstoken = "accesstoken";
  static const admincommission = "adminCommission";

  static const isGuestUser = "isGuestUser";
  static const guestUserData = "guestUserData";

  static late SharedPreferences pref;

  static initPref() async {
    pref = await SharedPreferences.getInstance();
  }

  static bool getBoolean(String key) => pref.getBool(key) ?? false;

  static Future<void> setBoolean(String key, bool value) async =>
      await pref.setBool(key, value);

  static String getString(String key) => pref.getString(key) ?? "";

  static Future<void> setString(String key, String value) async =>
      await pref.setString(key, value);

  static int getInt(String key) => pref.getInt(key) ?? 0;

  static Future<void> setInt(String key, int value) async =>
      await pref.setInt(key, value);

  static Future<void> clearSharPreference() async => await pref.clear();

  static Future<void> clearKeyData(String key) async => await pref.remove(key);
}
