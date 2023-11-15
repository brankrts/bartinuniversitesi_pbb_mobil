// ignore: file_names
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:pddmobile/models/notification_cache_model.dart';
import 'package:pddmobile/services/hive_manager.dart';

class NotificationState extends ChangeNotifier {
  List<NotificationCacheModel> _notifications = [];
  HiveCacheManager cacheManager = HiveCacheManager.getInstance();
  bool _isThereNewNotification = false;
  final List<String> _uuids = [];

  List<NotificationCacheModel> get notifications => _notifications;

  bool get isThereNewNotification {
    return _isThereNewNotification;
  }

  void setNotificationReadState(
      NotificationCacheModel currentNotification) async {
    _notifications = _notifications.map((notification) {
      if (currentNotification.uuid == notification.uuid) {
        notification.notification.isRead = true;
      }
      return notification;
    }).toList();
    _isThereNewNotification = _notifications
        .any((notification) => notification.notification.isRead == false);
    cacheManager.addItem(_notifications);

    notifyListeners();
  }

  void setNotifications(List<NotificationCacheModel> notifications,
      {bool isCache = false}) async {
    if (notifications.isEmpty) return;
    for (NotificationCacheModel notification in notifications) {
      if (!_uuids.contains(notification.uuid)) {
        _uuids.add(notification.uuid);
        _notifications.add(notification);
      }
    }

    _notifications.sort((a, b) {
      return DateFormat('dd/MM/yyyy')
          .parse(b.notification.date)
          .compareTo(DateFormat("dd/MM/yyyy").parse(a.notification.date));
    });
    _isThereNewNotification =
        _notifications.any((element) => element.notification.isRead == false);
    if (!isCache) {
      cacheManager.addItem(_notifications);
    }
    notifyListeners();
  }
}
