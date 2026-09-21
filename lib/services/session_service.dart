import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String key = 'is_logged_in';

  static Future<void> login() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, true);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, false);
  }
}
