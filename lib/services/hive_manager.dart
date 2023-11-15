import 'package:hive_flutter/adapters.dart';
import 'package:pddmobile/models/notification_cache_model.dart';

/*
What is your first and last name?
What is the name of your organizational unit?
What is the name of your organization?
What is the name of your City or Locality?
What is the name of your State or Province?
What is the two-letter country code for this unit?



\ */
class HiveCacheManager {
  Box<NotificationCacheModel>? _box;
  static HiveCacheManager? _instance;

  HiveCacheManager._internal();

  static HiveCacheManager getInstance() {
    _instance = _instance ?? HiveCacheManager._internal();
    return _instance!;
  }

  Future<void> init() async {
    _box = _box ??
        await Hive.openBox<NotificationCacheModel>("_notificationCache");
  }

  Future<void> addItem(List<NotificationCacheModel> newNotifications) async {
    await clearAll();
    await _box?.addAll(newNotifications);
  }

  Future<void> putItems(List<NotificationCacheModel> models) async {
    await _box?.putAll(Map.fromEntries(models.map((e) => MapEntry(e.uuid, e))));
  }

  List<NotificationCacheModel>? getNotifications() {
    return _box?.values.toList();
  }

  Future<void> clearAll() async {
    await _box?.clear();
  }
}
