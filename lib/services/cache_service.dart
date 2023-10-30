import 'dart:convert';
import 'package:pddmobile/config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static final String _cacheKey = ApplicationConfig.notificationCacheKey;

  Future<void> cacheData(List<Map<String, dynamic>> data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonData = jsonEncode(data);
    await prefs.setString(_cacheKey, jsonData);
  }

  Future<List<Map<String, dynamic>>?> getCacheData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonData = prefs.getString(_cacheKey);
    if (jsonData != null) {
      final data = jsonDecode(jsonData) as List;
      return List<Map<String, dynamic>>.from(
          data.map((e) => e as Map<String, dynamic>));
    }
    return null;
  }

  Future<void> clearCache() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
  }

  Future<void> cacheIfNotCache(List<Map<String, dynamic>> notifications) async {
    List<Map<String, dynamic>>? cachedData = await getCacheData();
    if (cachedData != null) {
      List<Map<String, dynamic>> updatedCachedData = List.from(cachedData);
      for (var cached in cachedData) {
        for (var element in notifications) {
          if (cached['uuid'] != element['uuid']) {
            updatedCachedData.add(element);
          }
        }
      }
      await cacheData(updatedCachedData);
      return;
    }
    await cacheData(notifications);
  }
}
