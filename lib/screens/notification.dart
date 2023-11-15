import 'package:flutter/material.dart';
import 'package:pddmobile/config/config.dart';
import 'package:pddmobile/models/base_model.dart';
import 'package:pddmobile/models/notification_cache_model.dart';
import 'package:pddmobile/screens/download_page.dart';
import 'package:pddmobile/screens/pdf_viewer.dart';
import 'package:pddmobile/screens/web_viewer.dart';
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
                newSet.add(notificationState.notifications[index].uuid);
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
  final NotificationCacheModel notification;

  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final notificationState = Provider.of<NotificationState>(context);
    Raporverileri currentNotification = notification.notification.element;
    var state = notification.notification.state;
    var date = notification.notification.date;
    String? title = currentNotification.kararbaslik?.veri;
    bool isRead = notification.notification.isRead;
    var header = currentNotification.kararanabaslik?.veri;

    String? pdfLink = currentNotification.karardosya?.veri ??
        currentNotification.karardosyayolu?.veri;
    if (title != null) {
      title = title.endsWith(ApplicationConfig.addKey)
          ? title.replaceAll(ApplicationConfig.addKey, "")
          : title;
      title = title.endsWith(ApplicationConfig.updateKey)
          ? title.replaceAll(ApplicationConfig.updateKey, "")
          : title;
    }

    return notificationItems(context, notificationState, header, date, title,
        state, isRead, pdfLink);
  }

  List<String> processUrl(String? url) {
    String startValue = "https://form.bartin.edu.tr";
    List<String> processedUrl = ['null', 'null'];
    String pdf = "pdf";
    String doc = "doc";
    String network = "network";
    if (url!.isNotEmpty) {
      if (url.startsWith("/dosyalar/")) {
        url = startValue + url;
      }
      if (url.endsWith(".pdf")) {
        processedUrl = [url, pdf];
      }
      if (url.endsWith(".doc") | url.endsWith(".docx")) {
        processedUrl = [url, doc];
      }
      if (!(url.endsWith(".pdf") |
          url.endsWith(".doc") |
          url.endsWith(".docx"))) {
        processedUrl = [url, network];
      }
      return processedUrl;
    }
    return processedUrl;
  }

  void _showSingleDownloadModal(BuildContext context, String url) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.height * 0.4,
          child: SingleDownloadScreen(url: url),
        );
      },
    );
  }

  void showUrlNotFoundModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 100,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.warning,
                color: Colors.amber,
                size: 40.0,
              ),
              SizedBox(height: 10.0),
              Text(
                "İçerik ile ilişkilendirilmiş URL adresi bulunamadı!",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
        );
      },
    );
  }

  Card notificationItems(
      BuildContext context,
      NotificationState notificationState,
      String? header,
      String date,
      String? title,
      String state,
      bool isRead,
      String? pdfLink) {
    var processedUrl = processUrl(pdfLink);
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
          if (processedUrl[0] != 'null') {
            if (processedUrl[1] == "doc" || processedUrl[1] == "docx") {
              _showSingleDownloadModal(context, processedUrl[0]);
            } else {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => processedUrl[1] == "pdf"
                      ? PdfViewer(
                          pdfUrl: processedUrl[0],
                        )
                      : WebViewer(
                          url: processedUrl[0],
                        )));
            }
          } else {
            showUrlNotFoundModal(context);
          }
          notificationState.setNotificationReadState(notification);
        },
      ),
    );
  }
}
