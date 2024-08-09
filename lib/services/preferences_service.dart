import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String THEME_KEY = 'isDarkMode';
  static const String SORT_KEY = 'sortOrder';

  Future<bool> getIsDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(THEME_KEY) ?? false;
  }

  Future<void> setIsDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(THEME_KEY, value);
  }

  Future<String> getSortOrder() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SORT_KEY) ?? 'title';
  }

  Future<void> setSortOrder(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SORT_KEY, value);
  }
}
