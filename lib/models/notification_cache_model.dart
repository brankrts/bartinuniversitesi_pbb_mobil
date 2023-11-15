import 'package:hive_flutter/adapters.dart';
import 'package:pddmobile/models/notification_model.dart';

part 'notification_cache_model.g.dart';

@HiveType(typeId: 0)
class NotificationCacheModel {
  @HiveField(0)
  String uuid;

  @HiveField(1)
  NotificationModel notification;

  NotificationCacheModel({
    required this.uuid,
    required this.notification,
  });

  NotificationCacheModel.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        notification = NotificationModel.fromJson(json['notification']);

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'notification': notification.toJson(),
      };
}
