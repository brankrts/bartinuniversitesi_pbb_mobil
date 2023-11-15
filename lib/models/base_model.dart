import 'package:hive_flutter/adapters.dart';
part 'base_model.g.dart';

@HiveType(typeId: 2)
class BaseModel {
  @HiveField(0)
  List<Raporverileri>? raporverileri;

  BaseModel({this.raporverileri});

  BaseModel.fromJson(Map<String, dynamic> json) {
    if (json['raporverileri'] != null) {
      raporverileri = <Raporverileri>[];
      json['raporverileri'].forEach((v) {
        raporverileri!.add(Raporverileri.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (raporverileri != null) {
      data['raporverileri'] = raporverileri!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

@HiveType(typeId: 3)
class Raporverileri {
  @HiveField(0)
  Kararanabaslik? kararanabaslik;

  @HiveField(1)
  Kararbaslik? kararbaslik;

  @HiveField(2)
  Karartarih? karartarih;

  @HiveField(3)
  Karartarih? kararno;

  @HiveField(4)
  Karartarih? esasno;

  @HiveField(5)
  Karartarih? karardosyayolu;

  @HiveField(6)
  Karardosya? karardosya;

  Raporverileri(
      {this.kararanabaslik,
      this.kararbaslik,
      this.karartarih,
      this.kararno,
      this.esasno,
      this.karardosyayolu,
      this.karardosya});

  Raporverileri.fromJson(Map<String, dynamic> json) {
    kararanabaslik = json['kararanabaslik'] != null
        ? Kararanabaslik.fromJson(json['kararanabaslik'])
        : null;
    kararbaslik = json['kararbaslik'] != null
        ? Kararbaslik.fromJson(json['kararbaslik'])
        : null;
    karartarih = json['karartarih'] != null
        ? Karartarih.fromJson(json['karartarih'])
        : null;
    kararno =
        json['kararno'] != null ? Karartarih.fromJson(json['kararno']) : null;
    esasno =
        json['esasno'] != null ? Karartarih.fromJson(json['esasno']) : null;
    karardosyayolu = json['karardosyayolu'] != null
        ? Karartarih.fromJson(json['karardosyayolu'])
        : null;
    karardosya = json['karardosya'] != null
        ? Karardosya.fromJson(json['karardosya'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (kararanabaslik != null) {
      data['kararanabaslik'] = kararanabaslik!.toJson();
    }
    if (kararbaslik != null) {
      data['kararbaslik'] = kararbaslik!.toJson();
    }
    if (karartarih != null) {
      data['karartarih'] = karartarih!.toJson();
    }
    if (kararno != null) {
      data['kararno'] = kararno!.toJson();
    }
    if (esasno != null) {
      data['esasno'] = esasno!.toJson();
    }
    if (karardosyayolu != null) {
      data['karardosyayolu'] = karardosyayolu!.toJson();
    }
    if (karardosya != null) {
      data['karardosya'] = karardosya!.toJson();
    }
    return data;
  }
}

@HiveType(typeId: 4)
class Kararanabaslik {
  @HiveField(0)
  String? label;

  @HiveField(1)
  String? veri;

  @HiveField(2)
  String? deger;

  Kararanabaslik({this.label, this.veri, this.deger});

  Kararanabaslik.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    veri = json['veri'];
    deger = json['deger'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['veri'] = veri;
    data['deger'] = deger;
    return data;
  }
}

@HiveType(typeId: 5)
class Kararbaslik {
  @HiveField(0)
  String? label;

  @HiveField(1)
  bool? listedegoster;

  @HiveField(2)
  String? veri;

  Kararbaslik({this.label, this.listedegoster, this.veri});

  Kararbaslik.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    listedegoster = json['listedegoster'];
    veri = json['veri'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['listedegoster'] = listedegoster;
    data['veri'] = veri;
    return data;
  }
}

@HiveType(typeId: 6)
class Karartarih {
  @HiveField(0)
  String? label;

  @HiveField(1)
  String? veri;

  Karartarih({this.label, this.veri});

  Karartarih.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    veri = json['veri'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['veri'] = veri;
    return data;
  }
}

@HiveType(typeId: 7)
class Karardosya {
  @HiveField(0)
  String? label;

  @HiveField(1)
  String? veri;

  @HiveField(2)
  int? url;

  Karardosya({this.label, this.veri, this.url});

  Karardosya.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    if (json['veri'] is List) {
      if (json['veri'].length > 0) {
        veri = json['veri'][0];
      } else {
        veri = null;
      }
    }
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['veri'] = veri;
    data['url'] = url;
    return data;
  }
}
