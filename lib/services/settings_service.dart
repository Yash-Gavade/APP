import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService extends ChangeNotifier {
  static const String _keyLanguage = 'language';
  static const String _keyTheme = 'theme';
  static const String _keyNotifications = 'notifications';
  static const String _keyUnits = 'units';
  static const String _keySound = 'sound';
  static const String _keyVibration = 'vibration';

  final SharedPreferences _prefs;
  
  SettingsService(this._prefs) {
    _loadSettings();
  }

  // Default values
  Locale _locale = const Locale('en');
  ThemeMode _themeMode = ThemeMode.system;
  bool _notificationsEnabled = true;
  bool _useMetricUnits = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

  // Getters
  Locale get locale => _locale;
  ThemeMode get themeMode => _themeMode;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get useMetricUnits => _useMetricUnits;
  bool get soundEnabled => _soundEnabled;
  bool get vibrationEnabled => _vibrationEnabled;

  void _loadSettings() {
    _locale = Locale(_prefs.getString(_keyLanguage) ?? 'en');
    _themeMode = ThemeMode.values[_prefs.getInt(_keyTheme) ?? 0];
    _notificationsEnabled = _prefs.getBool(_keyNotifications) ?? true;
    _useMetricUnits = _prefs.getBool(_keyUnits) ?? true;
    _soundEnabled = _prefs.getBool(_keySound) ?? true;
    _vibrationEnabled = _prefs.getBool(_keyVibration) ?? true;
    notifyListeners();
  }

  Future<void> updateLanguage(String languageCode) async {
    _locale = Locale(languageCode);
    await _prefs.setString(_keyLanguage, languageCode);
    notifyListeners();
  }

  Future<void> updateTheme(ThemeMode mode) async {
    _themeMode = mode;
    await _prefs.setInt(_keyTheme, mode.index);
    notifyListeners();
  }

  Future<void> updateNotifications(bool enabled) async {
    _notificationsEnabled = enabled;
    await _prefs.setBool(_keyNotifications, enabled);
    notifyListeners();
  }

  Future<void> updateUnits(bool useMetric) async {
    _useMetricUnits = useMetric;
    await _prefs.setBool(_keyUnits, useMetric);
    notifyListeners();
  }

  Future<void> updateSound(bool enabled) async {
    _soundEnabled = enabled;
    await _prefs.setBool(_keySound, enabled);
    notifyListeners();
  }

  Future<void> updateVibration(bool enabled) async {
    _vibrationEnabled = enabled;
    await _prefs.setBool(_keyVibration, enabled);
    notifyListeners();
  }

  Future<void> resetSettings() async {
    await _prefs.clear();
    _loadSettings();
  }
} 