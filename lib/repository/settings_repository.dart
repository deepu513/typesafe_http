import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:typesafehttp/setting_key.dart';

class SettingsRepository {
  static SettingsRepository _instance;
  static SharedPreferences _preferences;

  SettingsRepository._();

  static Future<SettingsRepository> getInstance() async {
    _instance ??= SettingsRepository._();

    _preferences ??= await SharedPreferences.getInstance();

    return _instance;
  }

  T get<T>(SettingKey key, {T defaultValue}) {
    if (_preferences != null) {
      return _preferences.containsKey(key.toString())
          ? _preferences?.get(key.toString())
          : defaultValue;
    }
    return defaultValue;
  }

  Future<bool> saveValue<V>(SettingKey key, V value) {
    if (value is String) {
      return _preferences?.setString(key.toString(), value);
    } else if (value is bool) {
      return _preferences?.setBool(key.toString(), value);
    } else if (value is int) {
      return _preferences?.setInt(key.toString(), value);
    } else if (value is double) {
      return _preferences?.setDouble(key.toString(), value);
    } else {
      return Future.value(false);
    }
  }
}
