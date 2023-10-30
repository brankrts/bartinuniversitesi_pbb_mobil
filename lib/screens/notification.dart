import 'package:flutter/material.dart';
import 'package:pddmobile/config/config.dart';
import 'package:pddmobile/models/base_model.dart';
import 'package:pddmobile/services/cache_service.dart';
import 'package:pddmobile/state/notificationState.dart';
import 'package:provider/provider.dart';

class Bildirimler extends StatefulWidget {
  const Bildirimler({super.key});

  @override
  State<Bildirimler> createState() => _BildirimlerState();
}

class _BildirimlerState extends State<Bildirimler> {
  static Set<String> newSet = {};

  Container notificationNotFound() {
    return Container(
      alignment: Alignment.center,
      child: const Text(
        'Henüz bildirim yok',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notificationState = Provider.of<NotificationState>(context);
    return Scaffold(
      body: notificationState.notifications.isEmpty
          ? notificationNotFound()
          : ListView.separated(
              itemCount: notificationState.notifications.length,
              itemBuilder: (BuildContext context, int index) {
                newSet.add(notificationState.notifications[index]['uuid']);
                return NotificationCard(
                  notification: notificationState.notifications[index],
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final Map<String, dynamic> notification;

  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final notificationState = Provider.of<NotificationState>(context);
    Raporverileri currentNotification = notification['notification']['element'];
    var state = notification['notification']['state'];
    var date = notification['notification']['date'] ??
        currentNotification.karartarih?.veri;
    String? title = currentNotification.kararbaslik?.veri;
    bool isRead = notification['notification']['isRead'];
    var header = currentNotification.kararanabaslik?.veri;
    if (title != null) {
      title = title.endsWith(ApplicationConfig.addKey)
          ? title.replaceAll(ApplicationConfig.addKey, "")
          : title;
      title = title.endsWith(ApplicationConfig.updateKey)
          ? title.replaceAll(ApplicationConfig.updateKey, "")
          : title;
    }
    CacheService().clearCache();

    return Card(
      elevation: 3.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: ListTile(
        onLongPress: (() {
          notificationState.setNotificationReadState(notification);
        }),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        title: Text(
          "$header",
          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15.0),
            Text(
              'Tarih: $date',
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 5.0),
            Text(
              'Aciklama: $title',
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  state == "ADDED" ? 'Eklendi' : "Guncellendi",
                  style: TextStyle(
                      color: state == "ADDED" ? Colors.green : Colors.blue,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  isRead ? "OKUNDU" : 'YENI',
                  style: TextStyle(
                      color: isRead ? Colors.red : Colors.blue,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          // Bildirime tıklanınca yapılacak işlemler buraya gelebilir
        },
      ),
    );
  }
}
