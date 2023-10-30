// ignore: file_names
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:pddmobile/services/cache_service.dart';

class NotificationState extends ChangeNotifier {
  List<Map<String, dynamic>> _notifications = [];
  bool _isThereNewNotification = false;
  final List<String> _uuids = [];

  List<Map<String, dynamic>> get notifications => _notifications;

  bool get isThereNewNotification {
    return _isThereNewNotification;
  }

  void setNotificationReadState(
      Map<String, dynamic> currentNotification) async {
    _notifications = _notifications.map((notification) {
      if (currentNotification['uuid'] == notification['uuid']) {
        notification['notification']["isRead"] = true;
      }
      return notification;
    }).toList();
    _isThereNewNotification = _notifications
        .any((element) => element['notification']['isRead'] == false);

    await CacheService().cacheIfNotCache(notifications);
    notifyListeners();
  }

  void setNotifications(List<Map<String, dynamic>> notifications) async {
    if (notifications.isEmpty) return;
    for (var notification in notifications) {
      if (!_uuids.contains(notification['uuid'])) {
        _uuids.add(notification['uuid']);
        _notifications.add(notification);
      }
    }

    _notifications.sort((a, b) {
      return DateFormat('dd/MM/yyyy')
          .parse(b['notification']['date'] ??
              b['notification']['element'].karartarih.veri)
          .compareTo(DateFormat("dd/MM/yyyy").parse(a['notification']['date'] ??
              a['notification']['element'].karartarih.veri));
    });
    _isThereNewNotification = _notifications
        .any((element) => element['notification']['isRead'] == false);
    await CacheService().cacheIfNotCache(notifications);
    notifyListeners();
  }
}
