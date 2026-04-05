import 'package:shared_preferences/shared_preferences.dart';

/// A lightweight, synchronous-read cache backed by [SharedPreferences].
///
/// Call [CacheHelper.init] once at app startup (before [runApp]) to load
/// the preferences instance; all subsequent [getData] / [saveData] calls
/// are then available synchronously.
class CacheHelper {
  CacheHelper._();

  static late SharedPreferences _prefs;

  /// Must be called once in [main] before [runApp].
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ── Write ──────────────────────────────────────────────────────────────────

  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    if (value is String)  return _prefs.setString(key, value);
    if (value is int)     return _prefs.setInt(key, value);
    if (value is double)  return _prefs.setDouble(key, value);
    if (value is bool)    return _prefs.setBool(key, value);
    throw ArgumentError(
      'CacheHelper.saveData: unsupported type ${value.runtimeType}',
    );
  }

  // ── Read ───────────────────────────────────────────────────────────────────

  /// Returns the stored value for [key], or `null` if not found.
  static dynamic getData({required String key}) => _prefs.get(key);

  // ── Delete ─────────────────────────────────────────────────────────────────

  static Future<bool> removeData({required String key}) =>
      _prefs.remove(key);

  static Future<bool> clearAll() => _prefs.clear();
}

