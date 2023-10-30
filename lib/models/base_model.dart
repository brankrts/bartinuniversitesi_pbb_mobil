class BaseModel {
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

class Raporverileri {
  Kararanabaslik? kararanabaslik;
  Kararbaslik? kararbaslik;
  Karartarih? karartarih;
  Karartarih? kararno;
  Karartarih? esasno;
  Karartarih? karardosyayolu;
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

class Kararanabaslik {
  String? label;
  String? veri;
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

class Kararbaslik {
  String? label;
  bool? listedegoster;
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

class Karartarih {
  String? label;
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

class Karardosya {
  String? label;
  String? veri;
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
