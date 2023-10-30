import 'dart:math';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:pddmobile/config/config.dart';

import '../models/base_model.dart';

final dio = Dio();

String baseUrl = "https://form.bartin.edu.tr/rapor/personel/";
String jsonAdded = "&json=1";
String urlPart2 = ".html?kararanabaslik__e=";
String urlSearchPart2 = ".html?&kararbaslik__ara=";
List<String> modules = [
  CategoryUrls.dpbUygulamalari,
  CategoryUrls.kararModulu,
  CategoryUrls.karsilartirmaCetvelleri,
  CategoryUrls.mevzuatHazirlama,
  CategoryUrls.maliUygulamalar,
  CategoryUrls.temimlerModulu,
  CategoryUrls.yokUygulamalari
];

// Map<String, int> requestCount = {
//   "kararlar": 6,
//   "yok-uygulamalari": 27,
//   "dpb-uygulamalari": 53,
//   "mali-uygulamalar": 4,
//   "tamimler": 13,
//   "karsilastirma-cetvelleri": 7,
//   "mevzuat-hazirlama": 1
// };
Future<BaseModel> fetchData(String? module, String? index) async {
  if (index != null && module != null) {
    final response =
        await dio.get(baseUrl + module + urlPart2 + index + jsonAdded);
    var model = BaseModel.fromJson(response.data);
    return model;
  }
  return BaseModel();
}

String generateUuid(String payload) {
  var bytes =
      utf8.encode(payload); // Metni UTF-8 formatında byte dizisine dönüştürme
  var digest = sha1.convert(bytes); // SHA-1 algoritması ile hash oluşturma

  return digest.toString();
}

List<Map<String, dynamic>> notificationChecker(BaseModel model) {
  List<Map<String, dynamic>> notifications = [];
  List<String> states = [ApplicationConfig.addKey, ApplicationConfig.updateKey];

// fake notifications
  for (int i = 0; i < 5; i++) {
    if (model.raporverileri!.length < 10) break;
    int randomValue = Random().nextInt(model.raporverileri!.length);
    String? description = model.raporverileri![randomValue].kararbaslik!.veri;
    if (description != null) {
      String state = states[Random().nextInt(2)];
      description = description + state;
      model.raporverileri![randomValue].kararbaslik!.veri = description;
    }
  }
  for (var element in model.raporverileri!) {
    var description = element.kararbaslik?.veri;
    var date = element.karartarih?.veri;
    var title = element.kararanabaslik?.veri;
    if (description is String) {
      String formattedDateNow = DateFormat("dd/MM/yyy").format(DateTime.now());
      String payload = "$title-$description-$date";
      if (description.endsWith(ApplicationConfig.addKey)) {
        notifications.add(date == null
            ? {
                "uuid": generateUuid(payload),
                "notification": {
                  "element": element,
                  "state": "ADDED",
                  "date": formattedDateNow,
                  "isRead": false
                }
              }
            : {
                "uuid": generateUuid(payload),
                "notification": {
                  "element": element,
                  "state": "ADDED",
                  "isRead": false
                }
              });
      }
      if (description.endsWith(ApplicationConfig.updateKey)) {
        notifications.add(date == null
            ? {
                "uuid": generateUuid(payload),
                "notification": {
                  "element": element,
                  "state": "UPDATED",
                  "date": formattedDateNow,
                  "isRead": false
                }
              }
            : {
                "uuid": generateUuid(payload),
                "notification": {
                  "element": element,
                  "state": "UPDATED",
                  "isRead": false
                }
              });
      }
    }
  }
  return notifications;
}

Future<BaseModel?> searchData(String module, String search) async {
  final response =
      await dio.get(baseUrl + module + urlSearchPart2 + search + jsonAdded);
  if (response.data["raporverileri"].isNotEmpty) {
    var model = BaseModel.fromJson(response.data);
    return model;
  }
  return null;
}

Future<dynamic> searchWithResponse(String module, String search) async {
  final response =
      await dio.get(baseUrl + module + urlSearchPart2 + search + jsonAdded);

  if (response.data['raporverileri'] is List) {
    if (response.data['raporverileri'].isNotEmpty) {
      return response.data;
    }
  }
  return null;
}

Future<BaseModel?> searchAllData(String search) async {
  List<dynamic> responses = [];
  Map<String, dynamic> response = {"raporverileri": []};

  responses.add(await searchWithResponse(CategoryUrls.kararModulu, search));
  responses.add(await searchWithResponse(CategoryUrls.yokUygulamalari, search));
  responses.add(await searchWithResponse(CategoryUrls.dpbUygulamalari, search));
  responses.add(await searchWithResponse(CategoryUrls.maliUygulamalar, search));
  responses.add(await searchWithResponse(CategoryUrls.temimlerModulu, search));
  responses.add(
      await searchWithResponse(CategoryUrls.karsilartirmaCetvelleri, search));
  responses
      .add(await searchWithResponse(CategoryUrls.mevzuatHazirlama, search));
  if (response.isNotEmpty) {
    for (var item in responses) {
      if (item != null) {
        for (var element in item['raporverileri']) {
          response['raporverileri'].add(element);
        }
      }
    }
    var model = BaseModel.fromJson(response);

    return model;
  }
  return null;
}

class CategoryUrls {
  static String kararModulu = "kararlar";
  static String yokUygulamalari = "yok-uygulamalari";
  static String dpbUygulamalari = "dpb-uygulamalari";
  static String maliUygulamalar = "mali-uygulamalar";
  static String temimlerModulu = "tamimler";
  static String karsilartirmaCetvelleri = "karsilastirma-cetvelleri";
  static String mevzuatHazirlama = "mevzuat-hazirlama";
}
