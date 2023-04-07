class BaseModel {
  List<Raporverileri>? raporverileri;

  BaseModel({this.raporverileri});

  BaseModel.fromJson(Map<String, dynamic> json) {
    if (json['raporverileri'] != null) {
      raporverileri = <Raporverileri>[];
      json['raporverileri'].forEach((v) {
        raporverileri!.add(new Raporverileri.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.raporverileri != null) {
      data['raporverileri'] =
          this.raporverileri!.map((v) => v.toJson()).toList();
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
        ? new Kararanabaslik.fromJson(json['kararanabaslik'])
        : null;
    kararbaslik = json['kararbaslik'] != null
        ? new Kararbaslik.fromJson(json['kararbaslik'])
        : null;
    karartarih = json['karartarih'] != null
        ? new Karartarih.fromJson(json['karartarih'])
        : null;
    kararno = json['kararno'] != null
        ? new Karartarih.fromJson(json['kararno'])
        : null;
    esasno =
        json['esasno'] != null ? new Karartarih.fromJson(json['esasno']) : null;
    karardosyayolu = json['karardosyayolu'] != null
        ? new Karartarih.fromJson(json['karardosyayolu'])
        : null;
    karardosya = json['karardosya'] != null
        ? new Karardosya.fromJson(json['karardosya'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.kararanabaslik != null) {
      data['kararanabaslik'] = this.kararanabaslik!.toJson();
    }
    if (this.kararbaslik != null) {
      data['kararbaslik'] = this.kararbaslik!.toJson();
    }
    if (this.karartarih != null) {
      data['karartarih'] = this.karartarih!.toJson();
    }
    if (this.kararno != null) {
      data['kararno'] = this.kararno!.toJson();
    }
    if (this.esasno != null) {
      data['esasno'] = this.esasno!.toJson();
    }
    if (this.karardosyayolu != null) {
      data['karardosyayolu'] = this.karardosyayolu!.toJson();
    }
    if (this.karardosya != null) {
      data['karardosya'] = this.karardosya!.toJson();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['veri'] = this.veri;
    data['deger'] = this.deger;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['listedegoster'] = this.listedegoster;
    data['veri'] = this.veri;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['veri'] = this.veri;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['veri'] = this.veri;
    data['url'] = this.url;
    return data;
  }
}
