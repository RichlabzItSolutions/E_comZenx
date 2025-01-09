// import 'package:shared_preferences/shared_preferences.dart';
//
// class SharedPreferencesHelper {
//   // Singleton instance for SharedPreferencesHelper
//   static final SharedPreferencesHelper _instance = SharedPreferencesHelper._internal();
//   factory SharedPreferencesHelper() => _instance;
//   SharedPreferencesHelper._internal();
//
//   // Get the instance of SharedPreferences
//   Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
//
//   Future<void> saveUsername(String username) async {
//     final prefs = await _prefs;
//     prefs.setString('username', username);
//   }
//
//   Future<String?> getUsername() async {
//     final prefs = await _prefs;
//     return prefs.getString('username');
//   }
//
//   Future<void> clearData() async {
//     final prefs = await _prefs;
//     prefs.remove('username');
//   }
// }
