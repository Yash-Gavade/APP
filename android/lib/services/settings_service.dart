import 'package:shared_preferences.dart';
import 'package:flutter/material.dart';

class SettingsService extends ChangeNotifier {
  static const String _languageKey = 'language';
  static const String _themeKey = 'theme';
  static const String _notificationsKey = 'notifications';
  static const String _unitsKey = 'units';
  static const String _soundKey = 'sound';
  static const String _vibrationKey = 'vibration';
  
  final SharedPreferences _prefs;
  
  // Default values
  String _language = 'en';
  ThemeMode _theme = ThemeMode.system;
  bool _notifications = true;
  String _units = 'metric'; // metric or imperial
  bool _sound = true;
  bool _vibration = true;
  
  SettingsService(this._prefs) {
    _loadSettings();
  }
  
  // Getters
  String get language => _language;
  ThemeMode get theme => _theme;
  bool get notifications => _notifications;
  String get units => _units;
  bool get sound => _sound;
  bool get vibration => _vibration;
  
  // Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    _language = _prefs.getString(_languageKey) ?? 'en';
    _theme = ThemeMode.values[_prefs.getInt(_themeKey) ?? 0];
    _notifications = _prefs.getBool(_notificationsKey) ?? true;
    _units = _prefs.getString(_unitsKey) ?? 'metric';
    _sound = _prefs.getBool(_soundKey) ?? true;
    _vibration = _prefs.getBool(_vibrationKey) ?? true;
    notifyListeners();
  }
  
  // Save settings to SharedPreferences
  Future<void> _saveSettings() async {
    await _prefs.setString(_languageKey, _language);
    await _prefs.setInt(_themeKey, _theme.index);
    await _prefs.setBool(_notificationsKey, _notifications);
    await _prefs.setString(_unitsKey, _units);
    await _prefs.setBool(_soundKey, _sound);
    await _prefs.setBool(_vibrationKey, _vibration);
    notifyListeners();
  }
  
  // Update language
  Future<void> updateLanguage(String languageCode) async {
    if (_language != languageCode) {
      _language = languageCode;
      await _saveSettings();
    }
  }
  
  // Update theme
  Future<void> updateTheme(ThemeMode theme) async {
    if (_theme != theme) {
      _theme = theme;
      await _saveSettings();
    }
  }
  
  // Update notifications
  Future<void> updateNotifications(bool enabled) async {
    if (_notifications != enabled) {
      _notifications = enabled;
      await _saveSettings();
    }
  }
  
  // Update units
  Future<void> updateUnits(String units) async {
    if (_units != units) {
      _units = units;
      await _saveSettings();
    }
  }
  
  // Update sound
  Future<void> updateSound(bool enabled) async {
    if (_sound != enabled) {
      _sound = enabled;
      await _saveSettings();
    }
  }
  
  // Update vibration
  Future<void> updateVibration(bool enabled) async {
    if (_vibration != enabled) {
      _vibration = enabled;
      await _saveSettings();
    }
  }
  
  // Reset all settings to default
  Future<void> resetSettings() async {
    _language = 'en';
    _theme = ThemeMode.system;
    _notifications = true;
    _units = 'metric';
    _sound = true;
    _vibration = true;
    await _saveSettings();
  }
} 