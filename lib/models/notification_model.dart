import 'package:hive_flutter/adapters.dart';
import 'package:pddmobile/models/base_model.dart';
part 'notification_model.g.dart';

@HiveType(typeId: 1)
class NotificationModel {
  @HiveField(0)
  Raporverileri element;

  @HiveField(1)
  String state;

  @HiveField(2)
  String date;

  @HiveField(3)
  bool isRead;

  NotificationModel({
    required this.element,
    required this.state,
    required this.date,
    required this.isRead,
  });

  NotificationModel.fromJson(Map<String, dynamic> json)
      : element = Raporverileri.fromJson(json['element']),
        state = json['state'],
        date = json['date'],
        isRead = json['isRead'];

  Map<String, dynamic> toJson() => {
        'element': element.toJson(),
        'state': state,
        'date': date,
        'isRead': isRead,
      };
}
