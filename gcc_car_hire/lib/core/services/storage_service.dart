import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static late Box _userBox;
  static late Box _settingsBox;
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapters if needed
    // Hive.registerAdapter(UserAdapter());
    
    _userBox = await Hive.openBox('user_data');
    _settingsBox = await Hive.openBox('app_settings');
    _prefs = await SharedPreferences.getInstance();
  }

  // User Data Storage
  Future<void> saveUserData(String key, dynamic value) async {
    await _userBox.put(key, value);
  }

  T? getUserData<T>(String key) {
    return _userBox.get(key) as T?;
  }

  Future<void> removeUserData(String key) async {
    await _userBox.delete(key);
  }

  Future<void> clearUserData() async {
    await _userBox.clear();
  }

  // App Settings Storage
  Future<void> saveSetting(String key, dynamic value) async {
    await _settingsBox.put(key, value);
  }

  T? getSetting<T>(String key) {
    return _settingsBox.get(key) as T?;
  }

  // SharedPreferences for simple key-value storage
  Future<void> saveString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  Future<void> saveBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  Future<void> saveInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  Future<void> clear() async {
    await _prefs.clear();
  }

  // Authentication Token Management
  Future<void> saveAuthToken(String token) async {
    await saveString('auth_token', token);
  }

  String? getAuthToken() {
    return getString('auth_token');
  }

  Future<void> saveRefreshToken(String token) async {
    await saveString('refresh_token', token);
  }

  String? getRefreshToken() {
    return getString('refresh_token');
  }

  Future<void> clearAuthTokens() async {
    await remove('auth_token');
    await remove('refresh_token');
  }

  // User Preferences
  Future<void> saveLanguage(String languageCode) async {
    await saveSetting('language', languageCode);
  }

  String getLanguage() {
    return getSetting<String>('language') ?? 'en';
  }

  Future<void> saveThemeMode(String themeMode) async {
    await saveSetting('theme_mode', themeMode);
  }

  String getThemeMode() {
    return getSetting<String>('theme_mode') ?? 'system';
  }

  // Onboarding Status
  Future<void> setOnboardingCompleted(bool completed) async {
    await saveBool('onboarding_completed', completed);
  }

  bool isOnboardingCompleted() {
    return getBool('onboarding_completed') ?? false;
  }

  // First Launch
  Future<void> setFirstLaunch(bool isFirst) async {
    await saveBool('first_launch', isFirst);
  }

  bool isFirstLaunch() {
    return getBool('first_launch') ?? true;
  }
}
