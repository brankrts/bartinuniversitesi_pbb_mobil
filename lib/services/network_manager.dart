import 'package:dio/dio.dart';

import '../models/base_model.dart';

final dio = Dio();

String baseUrl = "https://form.bartin.edu.tr/rapor/personel/";
String jsonAdded = "&json=1";
String urlPart2 = ".html?kararanabaslik__e=";
String urlSearchPart2 = ".html?&kararbaslik__ara=";

Future<BaseModel> fetchData(String? module, String? index) async {
  if (index != null && module != null) {
    final response =
        await dio.get(baseUrl + module + urlPart2 + index + jsonAdded);
    var model = BaseModel.fromJson(response.data);
    return model;
  }
  return BaseModel();
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
  final url = baseUrl + module + urlSearchPart2 + search + jsonAdded;

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
