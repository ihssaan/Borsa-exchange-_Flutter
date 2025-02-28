class Borsam {
  bool? success;
  List<Result>? result;

  Borsam({this.success, this.result});

  Borsam.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = this.success;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  double? rate;
  double? lastprice;
  String? lastpricestr;
  double? hacim;
  String? hacimstr;
  double? min;
  String? minstr;
  double? max;
  String? maxstr;
  String? time;
  String? text;
  String? code;
  String? icon;
  String? iconUrl;
  Result({
    this.rate,
    this.lastprice,
    this.lastpricestr,
    this.hacim,
    this.hacimstr,
    this.min,
    this.minstr,
    this.max,
    this.maxstr,
    this.time,
    this.text,
    this.code,
    this.icon,
    this.iconUrl
  });

  Result.fromJson(Map<String, dynamic> json) {
    // Eğer gelen değer int türünde ise, onu double'a dönüştürüyoruz
    rate = json['rate'] is int ? (json['rate'] as int).toDouble() : json['rate'];
    lastprice = json['lastprice'] is int ? (json['lastprice'] as int).toDouble() : json['lastprice'];
    lastpricestr = json['lastpricestr'];
    hacim = json['hacim'] is int ? (json['hacim'] as int).toDouble() : json['hacim'];
    hacimstr = json['hacimstr'];
    min = json['min'] is int ? (json['min'] as int).toDouble() : json['min'];
    minstr = json['minstr'];
    max = json['max'] is int ? (json['max'] as int).toDouble() : json['max'];
    maxstr = json['maxstr'];
    time = json['time'];
    text = json['text'];
    code = json['code'];
    icon = json['icon'];
    iconUrl = json['iconUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rate'] = this.rate;
    data['lastprice'] = this.lastprice;
    data['lastpricestr'] = this.lastpricestr;
    data['hacim'] = this.hacim;
    data['hacimstr'] = this.hacimstr;
    data['min'] = this.min;
    data['minstr'] = this.minstr;
    data['max'] = this.max;
    data['maxstr'] = this.maxstr;
    data['time'] = this.time;
    data['text'] = this.text;
    data['code'] = this.code;
    data['icon'] = this.icon;
    data['iconUrl'] = this.iconUrl;
    return data;
  }
}
